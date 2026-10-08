import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/storage/open_database.dart';

part 'app_database.g.dart';

/// Lifecycle of a queued scan. `pending` → `sending` → `sent` | `failed`; a transport error returns it to `pending`.
enum QueueStatus { pending, sending, sent, failed }

/// Scans taken while offline (or that timed out), replayed strictly in order by `ScanQueueWorker`.
class ScanQueueItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// UUID sent to the backend so a resent scan is not applied twice.
  TextColumn get scanId => text().withDefault(const Constant(''))();

  /// `receive` | `load` | `deliver` | `toWarehouse` — the `ScanMode` name.
  TextColumn get type => text()();
  TextColumn get code => text()();
  BoolColumn get manualInput => boolean().withDefault(const Constant(false))();
  TextColumn get comment => text().nullable()();
  IntColumn get tripId => integer().nullable()();
  IntColumn get warehouseId => integer().nullable()();
  BoolColumn get paymentReceived => boolean().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get status =>
      textEnum<QueueStatus>().withDefault(const Constant('pending'))();
  TextColumn get lastError => text().nullable()();
  IntColumn get lastStatusCode => integer().nullable()();

  /// Backend `ParcelResponse` JSON after a successful replay.
  TextColumn get serverResponse => text().nullable()();
  DateTimeColumn get sentAt => dateTime().nullable()();
}

@DriftDatabase(tables: [ScanQueueItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 2) await m.addColumn(scanQueueItems, scanQueueItems.scanId);
    },
  );
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openDatabaseExecutor());
  ref.onDispose(db.close);
  return db;
});
