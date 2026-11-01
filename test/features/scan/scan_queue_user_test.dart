import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

void main() {
  late AppDatabase db;
  int? signedIn = 1;
  late ScanQueue queue;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    signedIn = 1;
    queue = ScanQueue(db, userId: () => signedIn);
  });

  tearDown(() => db.close());

  test('another user signed in neither sees nor sends the scans', () async {
    final id = await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'M718106-1', tripId: 13),
    );
    expect((await queue.pending()).single.id, id);

    signedIn = 2;
    expect(await queue.pending(), isEmpty);
    expect(await queue.watchAll().first, isEmpty);
    expect(await queue.watchPendingCount().first, 0);
    // the same code scanned by them is theirs, not a duplicate
    expect(
      await queue.enqueue(
        ScanMode.load,
        const ScanRequest(code: 'M718106-1', tripId: 13),
      ),
      isNotNull,
    );

    signedIn = 1;
    expect((await queue.pending()).single.id, id);
  });

  test(
    'a sent scan drops the old error; logging out forgets the sent ones only',
    () async {
      final sent = (await queue.enqueue(
        ScanMode.load,
        const ScanRequest(code: 'M1-1', tripId: 1),
      ))!;
      await queue.markRetry(sent, 1, 'network');
      await queue.markSent(sent, '{}');
      final waiting = (await queue.enqueue(
        ScanMode.load,
        const ScanRequest(code: 'M1-2', tripId: 1),
      ))!;

      final rows = await queue.watchAll().first;
      expect(rows.firstWhere((r) => r.id == sent).lastError, isNull);

      await queue.forgetSent();
      expect((await queue.watchAll().first).map((r) => r.id), [waiting]);
    },
  );
}
