import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Persistence for the offline scan queue (the worker decides when to send).
class ScanQueue {
  ScanQueue(this._db);

  final AppDatabase _db;

  $ScanQueueItemsTable get _t => _db.scanQueueItems;

  /// Adds a scan unless an identical one (same mode and code) is already waiting.
  /// Returns null when it was a duplicate.
  Future<int?> enqueue(ScanMode mode, ScanRequest req) async {
    if (await isPending(mode, req.code)) return null;
    return await _db
        .into(_t)
        .insert(
          ScanQueueItemsCompanion.insert(
            type: mode.name,
            code: req.code,
            manualInput: Value(req.manualInput),
            comment: Value(req.comment),
            tripId: Value(req.tripId),
            warehouseId: Value(req.warehouseId),
            paymentReceived: Value(req.paymentReceived),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<bool> isPending(ScanMode mode, String code) async {
    final row =
        await (_db.select(_t)
              ..where(
                (t) =>
                    t.type.equals(mode.name) &
                    t.code.equals(code) &
                    t.status.isIn(const ['pending', 'sending']),
              )
              ..limit(1))
            .getSingleOrNull();
    return row != null;
  }

  /// Oldest first — the order scans happened in.
  Future<List<ScanQueueItem>> pending() =>
      (_db.select(_t)
            ..where((t) => t.status.equals('pending'))
            ..orderBy([
              (t) => OrderingTerm.asc(t.createdAt),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .get();

  Stream<List<ScanQueueItem>> watchAll() =>
      (_db.select(_t)..orderBy([
            (t) => OrderingTerm.desc(t.createdAt),
            (t) => OrderingTerm.desc(t.id),
          ]))
          .watch();

  /// Codes (parcel or seat barcodes / TTNs) with a scan still waiting — for "queued" badges.
  Stream<Set<String>> watchPendingCodes() =>
      (_db.select(_t)
            ..where((t) => t.status.isIn(const ['pending', 'sending'])))
          .watch()
          .map((rows) => rows.map((r) => r.code).toSet());

  Stream<int> watchPendingCount() =>
      (_db.select(_t)
            ..where((t) => t.status.isIn(const ['pending', 'sending'])))
          .watch()
          .map((rows) => rows.length);

  Future<void> markSending(int id) => _write(
    id,
    const ScanQueueItemsCompanion(status: Value(QueueStatus.sending)),
  );

  Future<void> markSent(int id, String responseJson) => _write(
    id,
    ScanQueueItemsCompanion(
      status: const Value(QueueStatus.sent),
      serverResponse: Value(responseJson),
      sentAt: Value(DateTime.now()),
    ),
  );

  /// Transport failure: back to the line, counted.
  Future<void> markRetry(int id, int attempts, String error) => _write(
    id,
    ScanQueueItemsCompanion(
      status: const Value(QueueStatus.pending),
      attempts: Value(attempts),
      lastError: Value(error),
    ),
  );

  Future<void> markFailed(int id, String error, {int? statusCode}) => _write(
    id,
    ScanQueueItemsCompanion(
      status: const Value(QueueStatus.failed),
      lastError: Value(error),
      lastStatusCode: Value(statusCode),
    ),
  );

  /// Later pending scans of the same code cannot succeed after an earlier one failed.
  Future<void> failFollowing(ScanQueueItem failed, String error) =>
      (_db.update(_t)..where(
            (t) =>
                t.code.equals(failed.code) &
                t.status.equals('pending') &
                t.id.isBiggerThanValue(failed.id),
          ))
          .write(
            ScanQueueItemsCompanion(
              status: const Value(QueueStatus.failed),
              lastError: Value(error),
            ),
          );

  Future<void> retry(int id) => _write(
    id,
    const ScanQueueItemsCompanion(
      status: Value(QueueStatus.pending),
      lastError: Value(null),
    ),
  );

  Future<void> remove(int id) =>
      (_db.delete(_t)..where((t) => t.id.equals(id))).go();

  /// Sent rows are kept a week for the history view.
  Future<void> cleanup({Duration keepSent = const Duration(days: 7)}) =>
      (_db.delete(_t)..where(
            (t) =>
                t.status.equals('sent') &
                t.sentAt.isSmallerThanValue(DateTime.now().subtract(keepSent)),
          ))
          .go();

  Future<void> _write(int id, ScanQueueItemsCompanion data) =>
      (_db.update(_t)..where((t) => t.id.equals(id))).write(data);
}

final scanQueueProvider = Provider<ScanQueue>(
  (ref) => ScanQueue(ref.watch(databaseProvider)),
);

final queueItemsProvider = StreamProvider<List<ScanQueueItem>>(
  (ref) => ref.watch(scanQueueProvider).watchAll(),
);

final queuedCodesProvider = StreamProvider<Set<String>>(
  (ref) => ref.watch(scanQueueProvider).watchPendingCodes(),
);

final pendingCountProvider = StreamProvider<int>(
  (ref) => ref.watch(scanQueueProvider).watchPendingCount(),
);

/// Rebuilds a [ScanRequest] from a stored row.
ScanRequest requestOf(ScanQueueItem row) => ScanRequest(
  code: row.code,
  manualInput: row.manualInput,
  comment: row.comment,
  tripId: row.tripId,
  paymentReceived: row.paymentReceived,
  warehouseId: row.warehouseId,
);

ScanMode modeOf(ScanQueueItem row) => ScanMode.values.firstWhere(
  (m) => m.name == row.type,
  orElse: () => ScanMode.lookup,
);
