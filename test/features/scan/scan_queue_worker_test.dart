import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

const _parcel = {'id': 1, 'barcode': 'PT1111111111', 'status': 'IN_CAR'};

DioException _offline(String path) => DioException(
  requestOptions: RequestOptions(path: path),
  type: DioExceptionType.connectionError,
);

void main() {
  late AppDatabase db;
  late ScanQueue queue;
  late DioAdapter adapter;
  late ScanQueueWorker worker;
  late ScanService service;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = ScanQueue(db);
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    adapter = DioAdapter(dio: dio);
    final api = ScanApi(dio);
    worker = ScanQueueWorker(
      queue,
      api,
      backoffBase: const Duration(milliseconds: 10),
    );
    service = ScanService(api, queue);
  });

  tearDown(() async {
    worker.dispose();
    await db.close();
  });

  test(
    'offline scan is queued, duplicates rejected, lookup never queued',
    () async {
      adapter.onPost(
        '/api/scan/load',
        (s) => s.throws(0, _offline('/api/scan/load')),
        data: Matchers.any,
      );
      adapter.onGet(
        '/api/scan',
        (s) => s.throws(0, _offline('/api/scan')),
        queryParameters: {'code': 'PT1111111111'},
      );

      final first = await service.perform(
        ScanMode.load,
        'PT1111111111',
        params: const ScanParams(tripId: 7),
      );
      expect(first, isA<ScanQueued>());
      final again = await service.perform(
        ScanMode.load,
        'PT1111111111',
        params: const ScanParams(tripId: 7),
      );
      expect((again as ScanRejected).reason, ScanRejectReason.alreadyQueued);
      final lookup = await service.perform(ScanMode.lookup, 'PT1111111111');
      expect(lookup, isA<ScanFailure>());

      final rows = await queue.pending();
      expect(rows.single.tripId, 7);
      expect(rows.single.type, 'load');
    },
  );

  test('replays FIFO and stops at the first transport error', () async {
    await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'PT1111111111', tripId: 7),
    );
    await queue.enqueue(
      ScanMode.deliver,
      const ScanRequest(code: 'PT1111111111'),
    );
    await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'PT2222222222', tripId: 7),
    );

    adapter.onPost(
      '/api/scan/load',
      (s) => s.reply(200, _parcel),
      data: {'code': 'PT1111111111', 'manualInput': false, 'tripId': 7},
    );
    adapter.onPost(
      '/api/scan/deliver',
      (s) => s.throws(0, _offline('/api/scan/deliver')),
      data: Matchers.any,
    );

    final r = await worker.run();
    expect(r.sent, 1);
    expect(r.stoppedByTransport, isTrue);
    final all = await queue.watchAll().first;
    final byCode = {for (final x in all) '${x.type}:${x.code}': x};
    expect(byCode['load:PT1111111111']!.status, QueueStatus.sent);
    expect(byCode['deliver:PT1111111111']!.status, QueueStatus.pending);
    expect(byCode['deliver:PT1111111111']!.attempts, 1);
    // The third row was never attempted — order is preserved.
    expect(byCode['load:PT2222222222']!.status, QueueStatus.pending);
    expect(byCode['load:PT2222222222']!.attempts, 0);
  });

  test('4xx fails the row, cascades to later scans of the same code, continues with others', () async {
    await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'PT1111111111', tripId: 7),
    );
    await queue.enqueue(
      ScanMode.deliver,
      const ScanRequest(code: 'PT1111111111'),
    );
    await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'PT2222222222', tripId: 7),
    );

    adapter.onPost(
      '/api/scan/load',
      (s) => s.reply(400, {
        'title': 'Bad Request',
        'status': 400,
        'detail': 'Trip 7 cannot be changed',
      }),
      data: {'code': 'PT1111111111', 'manualInput': false, 'tripId': 7},
    );
    adapter.onPost(
      '/api/scan/load',
      (s) => s.reply(200, _parcel),
      data: {'code': 'PT2222222222', 'manualInput': false, 'tripId': 7},
    );

    final r = await worker.run();
    expect(r.sent, 1);
    expect(r.failed, 1);
    final all = await queue.watchAll().first;
    final byKey = {for (final x in all) '${x.type}:${x.code}': x};
    expect(byKey['load:PT1111111111']!.status, QueueStatus.failed);
    expect(byKey['load:PT1111111111']!.lastError, 'Trip 7 cannot be changed');
    expect(byKey['deliver:PT1111111111']!.status, QueueStatus.failed);
    expect(byKey['load:PT2222222222']!.status, QueueStatus.sent);

    // A failed row can be put back and will be retried on the next pass.
    await queue.retry(byKey['load:PT1111111111']!.id);
    expect((await queue.pending()).map((x) => x.code), ['PT1111111111']);
  });

  test('401 stops the run and keeps rows pending', () async {
    await queue.enqueue(
      ScanMode.receive,
      const ScanRequest(code: '20451549454007'),
    );
    adapter.onPost(
      '/api/scan/receive',
      (s) => s.reply(401, ''),
      data: Matchers.any,
    );
    final r = await worker.run();
    expect(r.stoppedByAuth, isTrue);
    expect((await queue.pending()).length, 1);
  });

  test('pending codes feed the queued badges', () async {
    await queue.enqueue(
      ScanMode.load,
      const ScanRequest(code: 'PT1111111111-2', tripId: 7),
    );
    expect(await queue.watchPendingCodes().first, {'PT1111111111-2'});
    expect(await queue.watchPendingCount().first, 1);
  });
}
