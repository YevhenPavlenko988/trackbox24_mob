import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:uuid/uuid.dart';

/// Persistence for the offline scan queue (the worker decides when to send). Each scan belongs to the user who
/// took it: another user signing in on the phone neither sees nor sends it.
class ScanQueue {
  ScanQueue(this._db, {this._userId});

  final AppDatabase _db;

  /// The signed-in user; without it (tests) every row is everyone's.
  final int? Function()? _userId;

  $ScanQueueItemsTable get _t => _db.scanQueueItems;

  /// The current user's rows, and those from before scans were tied to a user.
  Expression<bool> _mine($ScanQueueItemsTable t) {
    final userId = _userId;
    if (userId == null) return const Constant(true);
    final id = userId();
    return id == null
        ? t.userId.isNull()
        : t.userId.equals(id) | t.userId.isNull();
  }

  /// Adds a scan unless an identical one (same mode and code) is already waiting.
  /// Returns null when it was a duplicate.
  Future<int?> enqueue(ScanMode mode, ScanRequest req) async {
    if (await isPending(mode, req.code)) return null;
    return await _db
        .into(_t)
        .insert(
          ScanQueueItemsCompanion.insert(
            scanId: Value(const Uuid().v4()),
            userId: Value(_userId?.call()),
            type: mode.name,
            code: req.code,
            manualInput: Value(req.manualInput),
            comment: Value(req.comment),
            tripId: Value(req.tripId),
            warehouseId: Value(req.warehouseId),
            paymentReceived: Value(req.paymentReceived),
            paymentMethod: Value(req.paymentMethod?.name),
            paidCurrency: Value(req.paidCurrency),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<bool> isPending(ScanMode mode, String code) async {
    final row =
        await (_db.select(_t)
              ..where(
                (t) =>
                    _mine(t) &
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
            ..where((t) => _mine(t) & t.status.equals('pending'))
            ..orderBy([
              (t) => OrderingTerm.asc(t.createdAt),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .get();

  Stream<List<ScanQueueItem>> watchAll() =>
      (_db.select(_t)
            ..where(_mine)
            ..orderBy([
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.desc(t.id),
            ]))
          .watch();

  /// Codes (parcel or seat barcodes / TTNs) with a scan still waiting — for "queued" badges.
  Stream<Set<String>> watchPendingCodes() =>
      (_db.select(_t)..where(
            (t) => _mine(t) & t.status.isIn(const ['pending', 'sending']),
          ))
          .watch()
          .map((rows) => rows.map((r) => r.code).toSet());

  Stream<int> watchPendingCount() =>
      (_db.select(_t)..where(
            (t) => _mine(t) & t.status.isIn(const ['pending', 'sending']),
          ))
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
      // a transport error on an earlier try is no longer true
      lastError: const Value(null),
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
                _mine(t) &
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

  /// On logging out: the user's sent scans were their history; the ones still waiting stay for their next login.
  Future<void> forgetSent() =>
      (_db.delete(_t)..where((t) => _mine(t) & t.status.equals('sent'))).go();

  /// Dev menu only.
  Future<void> clearAll() => _db.delete(_t).go();

  Future<void> _write(int id, ScanQueueItemsCompanion data) =>
      (_db.update(_t)..where((t) => t.id.equals(id))).write(data);
}

final scanQueueProvider = Provider<ScanQueue>(
  (ref) => ScanQueue(
    ref.watch(databaseProvider),
    userId: () => switch (ref.read(authProvider)) {
      Authenticated(:final user) => user.id,
      _ => null,
    },
  ),
);

// The lists follow the signed-in user: another login, another queue.
final queueItemsProvider = StreamProvider<List<ScanQueueItem>>((ref) {
  ref.watch(authProvider);
  return ref.watch(scanQueueProvider).watchAll();
});

final queuedCodesProvider = StreamProvider<Set<String>>((ref) {
  ref.watch(authProvider);
  return ref.watch(scanQueueProvider).watchPendingCodes();
});

final pendingCountProvider = StreamProvider<int>((ref) {
  ref.watch(authProvider);
  return ref.watch(scanQueueProvider).watchPendingCount();
});

/// Rebuilds a [ScanRequest] from a stored row.
ScanRequest requestOf(ScanQueueItem row) => ScanRequest(
  code: row.code,
  manualInput: row.manualInput,
  comment: row.comment,
  tripId: row.tripId,
  paymentReceived: row.paymentReceived,
  paymentMethod: paymentMethodOf(row.paymentMethod),
  paidCurrency: row.paidCurrency,
  warehouseId: row.warehouseId,
);

/// A stored method name; an unknown one is dropped rather than sent back to the backend.
PaymentMethod? paymentMethodOf(String? name) => name == null
    ? null
    : PaymentMethod.values.firstWhere(
        (m) => m.name == name,
        orElse: () => PaymentMethod.unknown,
      );

ScanMode modeOf(ScanQueueItem row) => ScanMode.values.firstWhere(
  (m) => m.name == row.type,
  orElse: () => ScanMode.lookup,
);
