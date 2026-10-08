import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Replays queued scans in one batch request.
///
/// The backend applies them in scan order, each on its own, and ignores a scan whose id it has already
/// seen, so a resend is safe. A transport error leaves every row pending and schedules a retry; a 401 does
/// the same until the user logs in again; otherwise each row takes the verdict the backend returned for it.
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
    final rows = await _queue.pending();
    if (rows.isEmpty) return const RunResult();
    // Rows queued before the id column existed still have an empty scanId; give them one for this send.
    final items = [
      for (final row in rows)
        BatchScanItem(
          id: row.scanId.isEmpty ? 'row-${row.id}' : row.scanId,
          action: _actionOf(modeOf(row)),
          code: row.code,
          scannedAt: row.createdAt,
          manualInput: row.manualInput,
          comment: row.comment,
          tripId: row.tripId,
          paymentReceived: row.paymentReceived,
          warehouseId: row.warehouseId,
        ),
    ];

    final List<BatchScanResult> results;
    try {
      results = await _api.batch(items);
    } on ApiException catch (e) {
      final blocker = rows.first;
      if (e.isUnauthorized) {
        await _queue.markRetry(blocker.id, blocker.attempts, 'unauthorized');
        return const RunResult(stoppedByAuth: true);
      }
      final attempts = blocker.attempts + 1;
      await _queue.markRetry(blocker.id, attempts, e.kind.name);
      return RunResult(stoppedByTransport: true, attemptsOfBlocker: attempts);
    }

    final byId = {for (final r in results) r.id: r};
    var sent = 0;
    var failed = 0;
    for (var i = 0; i < rows.length; i++) {
      final row = rows[i];
      final result = byId[items[i].id];
      // Not in the response: leave it pending for the next run.
      if (result == null) continue;
      if (result.ok) {
        await _queue.markSent(
          row.id,
          jsonEncode(result.parcel?.toJson() ?? const <String, dynamic>{}),
        );
        sent++;
      } else {
        await _queue.markFailed(
          row.id,
          result.detail ?? 'HTTP ${result.status ?? 0}',
          statusCode: result.status,
        );
        failed++;
      }
    }
    return RunResult(sent: sent, failed: failed);
  }

  static String _actionOf(ScanMode mode) => switch (mode) {
    ScanMode.receive => 'RECEIVE',
    ScanMode.load => 'LOAD',
    ScanMode.deliver => 'DELIVER',
    ScanMode.toWarehouse => 'TO_WAREHOUSE',
    ScanMode.lookup => 'RECEIVE',
  };

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
