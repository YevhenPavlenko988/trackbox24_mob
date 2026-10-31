import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/core/api/offline_cache.dart';
import 'package:trackbox24_mob/core/storage/app_database.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';

void main() {
  late AppDatabase db;
  late DioAdapter adapter;
  late Dio dio;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
      extra: [OfflineCacheInterceptor(db)],
    );
    adapter = DioAdapter(dio: dio);
  });

  tearDown(() => db.close());

  // Airplane mode: every request fails before reaching the server, as Dio reports it.
  void offline() => dio.httpClientAdapter = _NoNetwork();
  void online() => dio.httpClientAdapter = adapter;

  test('a move opened online opens again without a connection', () async {
    adapter.onGet(
      '/api/parcels/7',
      (s) => s.reply(200, {'id': 7, 'barcode': 'M104521', 'kind': 'MOVE'}),
    );
    final api = ParcelApi(dio);
    expect((await api.get(7)).barcode, 'M104521');

    offline();
    expect((await api.get(7)).barcode, 'M104521');
  });

  test('warehouses are kept for the warehouse scan offline', () async {
    const query = {'active': true, 'size': 100};
    adapter.onGet(
      '/api/warehouses',
      (s) => s.reply(200, {
        'content': [
          {'id': 2, 'name': 'Львів'},
        ],
        'page': {'size': 100, 'number': 0, 'totalElements': 1, 'totalPages': 1},
      }),
      queryParameters: query,
    );
    final api = WarehouseApi(dio);
    expect((await api.listActive()).single.name, 'Львів');

    offline();
    expect((await api.listActive()).single.name, 'Львів');
  });

  test('nothing kept — the error as before; logging out forgets', () async {
    final api = ParcelApi(dio);
    offline();
    await expectLater(
      api.get(8),
      throwsA(
        isA<ApiException>().having((e) => e.isTransport, 'transport', true),
      ),
    );

    online();
    adapter.onGet('/api/parcels/9', (s) => s.reply(200, {'id': 9}));
    await api.get(9);
    await clearOfflineCache(db);
    offline();
    await expectLater(api.get(9), throwsA(isA<ApiException>()));
  });

  test('only the GETs a driver needs on the road are kept', () {
    bool kept(String method, String path) => isOfflineCached(
      RequestOptions(method: method, path: path, baseUrl: 'http://test'),
    );
    expect(kept('GET', '/api/trips'), isTrue);
    expect(kept('GET', '/api/trips/5'), isTrue);
    expect(kept('GET', '/api/trips/5/parcels'), isTrue);
    expect(kept('GET', '/api/parcels/7'), isTrue);
    expect(kept('GET', '/api/parcels'), isFalse);
    expect(kept('GET', '/api/parcels/7/history'), isFalse);
    expect(kept('POST', '/api/parcels/7'), isFalse);
  });
}

class _NoNetwork implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) => throw DioException(
    requestOptions: options,
    type: DioExceptionType.connectionError,
  );

  @override
  void close({bool force = false}) {}
}
