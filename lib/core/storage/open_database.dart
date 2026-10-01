import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// The on-device SQLite file; tests pass an in-memory executor to `AppDatabase` instead.
QueryExecutor openDatabaseExecutor() => driftDatabase(name: 'trackbox24');
