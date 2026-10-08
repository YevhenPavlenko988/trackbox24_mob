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

  /// The queue is replayed as one POST /api/scan/batch; the backend verdict per scan decides each row.
  Future<List<ScanQueueItem>> queued() => queue.watchAll().first;

  void mockBatch(int code, Object? body) => adapter.onPost(
    '/api/scan/batch',
    (s) => s.reply(code, body),
    data: Matchers.any,
  );

  Future<Map<String, ScanQueueItem>> threeScans() async {
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
    final rows = await queue.pending();
    return {for (final r in rows) '${r.type}:${r.code}': r};
  }

  test('one batch request clears every scan the backend accepted', () async {
    final rows = await threeScans();
    mockBatch(200, {
      'results': [
        for (final r in rows.values)
          {'id': r.scanId, 'ok': true, 'duplicate': false, 'parcel': _parcel},
      ],
    });

    final r = await worker.run();
    expect(r.sent, 3);
    expect(r.failed, 0);
    expect(adapter.history.length, 1, reason: 'one request, not one per scan');
    expect((await queued()).every((x) => x.status == QueueStatus.sent), isTrue);
  });

  test('a scan already applied earlier also leaves the queue', () async {
    await queue.enqueue(
      ScanMode.receive,
      const ScanRequest(code: '20451549454007'),
    );
    final row = (await queue.pending()).single;
    mockBatch(200, {
      'results': [
        {'id': row.scanId, 'ok': true, 'duplicate': true},
      ],
    });

    final r = await worker.run();
    expect(r.sent, 1);
    expect((await queued()).single.status, QueueStatus.sent);
  });

  test(
    'a rejected scan is marked failed, the others still go through',
    () async {
      final rows = await threeScans();
      mockBatch(200, {
        'results': [
          {
            'id': rows['load:PT1111111111']!.scanId,
            'ok': false,
            'duplicate': false,
            'status': 400,
            'detail': 'Рейс 7 не можна змінювати',
          },
          {
            'id': rows['deliver:PT1111111111']!.scanId,
            'ok': false,
            'duplicate': false,
            'status': 400,
            'detail': 'Місце не в машині',
          },
          {
            'id': rows['load:PT2222222222']!.scanId,
            'ok': true,
            'duplicate': false,
            'parcel': _parcel,
          },
        ],
      });

      final r = await worker.run();
      expect(r.sent, 1);
      expect(r.failed, 2);
      final byKey = {for (final x in await queued()) '${x.type}:${x.code}': x};
      expect(byKey['load:PT1111111111']!.status, QueueStatus.failed);
      expect(
        byKey['load:PT1111111111']!.lastError,
        'Рейс 7 не можна змінювати',
      );
      expect(byKey['load:PT2222222222']!.status, QueueStatus.sent);

      // A failed row can be put back and will be retried on the next pass.
      await queue.retry(byKey['load:PT1111111111']!.id);
      expect((await queue.pending()).map((x) => x.code), ['PT1111111111']);
    },
  );

  test(
    'a transport error keeps every scan pending and retries later',
    () async {
      await threeScans();
      adapter.onPost(
        '/api/scan/batch',
        (s) => s.throws(0, _offline('/api/scan/batch')),
        data: Matchers.any,
      );

      final r = await worker.run();
      expect(r.sent, 0);
      expect(r.stoppedByTransport, isTrue);
      expect((await queue.pending()).length, 3);
    },
  );

  test('401 stops the run and keeps rows pending', () async {
    await queue.enqueue(
      ScanMode.receive,
      const ScanRequest(code: '20451549454007'),
    );
    mockBatch(401, '');
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
