import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Replays queued scans strictly in FIFO order.
///
/// Rules: a transport error puts the row back and stops the run (order matters: load before
/// deliver for the same seat); a 4xx marks the row failed and fails later scans of the same code;
/// a 401 stops the run and keeps everything pending until the user logs in again.
class ScanQueueWorker {
  ScanQueueWorker(
    this._queue,
    this._api, {
    this.backoffBase = const Duration(seconds: 2),
    this.backoffMax = const Duration(seconds: 60),
  });

  final ScanQueue _queue;
  final ScanApi _api;
  final Duration backoffBase;
  final Duration backoffMax;

  bool _running = false;
  bool _runAgain = false;
  Timer? _retry;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;

  /// Last run summary for the UI; `null` while nothing has run yet.
  final ValueNotifier<RunResult?> lastRun = ValueNotifier(null);

  /// Subscribes to connectivity changes; call once at app start.
  void start() {
    _connectivity ??= Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) unawaited(run());
    });
    unawaited(run());
  }

  void dispose() {
    _retry?.cancel();
    unawaited(_connectivity?.cancel());
    lastRun.dispose();
  }

  /// Processes everything pending. Concurrent calls coalesce into one extra pass.
  Future<RunResult> run() async {
    if (_running) {
      _runAgain = true;
      return lastRun.value ?? const RunResult();
    }
    _running = true;
    _retry?.cancel();
    var result = const RunResult();
    try {
      await _queue.cleanup();
      result = await _pass();
      lastRun.value = result;
      if (result.stoppedByTransport) _scheduleRetry(result.attemptsOfBlocker);
    } finally {
      _running = false;
      if (_runAgain) {
        _runAgain = false;
        unawaited(run());
      }
    }
    return result;
  }

  Future<RunResult> _pass() async {
    var sent = 0;
    var failed = 0;
    final rows = await _queue.pending();
    for (final row in rows) {
      // A previous row in this pass may have failed this one (same code); re-read is cheap enough.
      if (!await _queue.isPending(modeOf(row), row.code)) continue;
      await _queue.markSending(row.id);
      try {
        final parcel = await _send(row);
        await _queue.markSent(row.id, jsonEncode(parcel.toJson()));
        sent++;
      } on ApiException catch (e) {
        if (e.isTransport) {
          await _queue.markRetry(row.id, row.attempts + 1, e.kind.name);
          return RunResult(
            sent: sent,
            failed: failed,
            stoppedByTransport: true,
            attemptsOfBlocker: row.attempts + 1,
          );
        }
        if (e.isUnauthorized) {
          await _queue.markRetry(row.id, row.attempts, 'unauthorized');
          return RunResult(sent: sent, failed: failed, stoppedByAuth: true);
        }
        final message = e.detail ?? e.title ?? 'HTTP ${e.status}';
        await _queue.markFailed(row.id, message, statusCode: e.status);
        await _queue.failFollowing(row, 'previous scan of this code failed');
        failed++;
      }
    }
    return RunResult(sent: sent, failed: failed);
  }

  Future<Parcel> _send(ScanQueueItem row) {
    final req = requestOf(row);
    return switch (modeOf(row)) {
      ScanMode.receive => _api.receive(req),
      ScanMode.load => _api.load(req),
      ScanMode.deliver => _api.deliver(req),
      ScanMode.toWarehouse => _api.toWarehouse(req),
      ScanMode.lookup => _api.lookup(row.code),
    };
  }

  void _scheduleRetry(int attempts) {
    final delay = Duration(
      milliseconds: min(
        backoffBase.inMilliseconds * pow(2, min(attempts, 10)).toInt(),
        backoffMax.inMilliseconds,
      ),
    );
    _retry?.cancel();
    _retry = Timer(delay, () => unawaited(run()));
  }
}

class RunResult {
  const RunResult({
    this.sent = 0,
    this.failed = 0,
    this.stoppedByTransport = false,
    this.stoppedByAuth = false,
    this.attemptsOfBlocker = 0,
  });

  final int sent;
  final int failed;
  final bool stoppedByTransport;
  final bool stoppedByAuth;
  final int attemptsOfBlocker;
}

/// One worker for the app's lifetime (kept alive explicitly).
final scanQueueWorkerProvider = Provider<ScanQueueWorker>((ref) {
  ref.keepAlive();
  final worker = ScanQueueWorker(
    ref.watch(scanQueueProvider),
    ref.watch(scanApiProvider),
  );
  ref.onDispose(worker.dispose);
  return worker;
});
