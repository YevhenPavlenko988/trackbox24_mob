import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/data/scan_api.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

const Map<String, dynamic> _parcelJson = {
  'id': 86,
  'barcode': 'PT9264428678',
  'status': 'RECEIVED_BY_REPRESENTATIVE',
  'seatsAmount': 2,
  'senderName': 'Автотест',
  'seats': [
    {'seatNumber': 1, 'barcode': 'PT9264428678-1', 'status': 'IN_CAR'},
    {
      'seatNumber': 2,
      'barcode': 'PT9264428678-2',
      'status': 'RECEIVED_BY_REPRESENTATIVE',
    },
  ],
  'someFutureField': 'ignored',
};

void main() {
  late DioAdapter adapter;
  late ScanService service;

  setUp(() {
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    adapter = DioAdapter(dio: dio);
    service = ScanService(ScanApi(dio), null);
  });

  test('lookup normalizes the code and parses the parcel', () async {
    adapter.onGet(
      '/api/scan',
      (s) => s.reply(200, _parcelJson),
      queryParameters: {'code': 'PT9264428678-2'},
    );
    final out = await service.perform(ScanMode.lookup, ' pt9264428678-2 ');
    expect(out, isA<ScanSuccess>());
    final p = (out as ScanSuccess).parcel;
    expect(p.barcode, 'PT9264428678');
    expect(p.status, ParcelStatus.RECEIVED_BY_REPRESENTATIVE);
    expect(p.seatCount, 2);
    expect(p.seatsIn(ParcelStatus.IN_CAR), 1);
  });

  test('unknown status value does not break parsing', () {
    final p = Parcel.fromJson({'id': 1, 'status': 'SOMETHING_NEW'});
    expect(p.status, ParcelStatus.unknown);
    expect(p.code, '#1');
  });

  test('receive rejects non-TTN codes before any request', () async {
    final out = await service.perform(ScanMode.receive, 'PT9264428678');
    expect(out, isA<ScanRejected>());
    expect((out as ScanRejected).reason, ScanRejectReason.notTtn);
  });

  test('an action mode rejects a code it cannot act on', () async {
    final out = await service.perform(ScanMode.load, 'hello');
    expect((out as ScanRejected).reason, ScanRejectReason.unknownCode);
  });

  test(
    'lookup asks the backend about any code, it knows more forms than we do',
    () async {
      adapter.onGet(
        '/api/scan',
        (s) => s.reply(404, {'title': 'Not Found', 'status': 404}),
        queryParameters: {'code': 'HELLO'},
      );
      final out = await service.perform(ScanMode.lookup, 'hello');
      expect((out as ScanFailure).error.isNotFound, isTrue);
    },
  );

  test('a Nova Poshta seat label is received by its waybill', () async {
    adapter.onGet(
      '/api/scan',
      (s) => s.reply(200, _parcelJson),
      queryParameters: {'code': '20451549454007'},
    );
    adapter.onPost(
      '/api/scan/receive',
      (s) => s.reply(200, _parcelJson),
      data: {'code': '20451549454007', 'manualInput': false},
    );
    // 18 digits = the waybill plus a seat number; the backend only receives by the 14-digit waybill.
    final out = await service.perform(ScanMode.receive, '204515494540070001');
    expect(out, isA<ScanSuccess>());
  });

  test('receive of an unknown TTN reports created=true', () async {
    adapter.onGet(
      '/api/scan',
      (s) => s.reply(404, {'title': 'Not Found', 'status': 404}),
      queryParameters: {'code': '20451549454007'},
    );
    adapter.onPost(
      '/api/scan/receive',
      (s) => s.reply(200, {..._parcelJson, 'npTtn': '20451549454007'}),
      data: {'code': '20451549454007', 'manualInput': true},
    );
    final out = await service.perform(
      ScanMode.receive,
      '20451549454007',
      manual: true,
    );
    expect(out, isA<ScanSuccess>());
    expect((out as ScanSuccess).created, isTrue);
  });

  test('load needs a trip and sends tripId', () async {
    final rejected = await service.perform(ScanMode.load, 'PT9264428678-1');
    expect((rejected as ScanRejected).reason, ScanRejectReason.tripRequired);

    adapter.onPost(
      '/api/scan/load',
      (s) => s.reply(200, _parcelJson),
      data: {'code': 'PT9264428678-1', 'manualInput': false, 'tripId': 7},
    );
    final ok = await service.perform(
      ScanMode.load,
      'PT9264428678-1',
      params: const ScanParams(tripId: 7),
    );
    expect(ok, isA<ScanSuccess>());
  });

  test(
    'deliver sends paymentReceived and surfaces backend 400 detail',
    () async {
      adapter.onPost(
        '/api/scan/deliver',
        (s) => s.reply(400, {
          'title': 'Bad Request',
          'status': 400,
          'detail': 'Parcel has no delivery price',
        }),
        data: {
          'code': 'PT9264428678-1',
          'manualInput': false,
          'paymentReceived': true,
        },
      );
      final out = await service.perform(
        ScanMode.deliver,
        'PT9264428678-1',
        params: const ScanParams(paymentReceived: true),
      );
      expect(out, isA<ScanFailure>());
      expect((out as ScanFailure).error.detail, 'Parcel has no delivery price');
    },
  );

  test('toWarehouse needs a warehouse', () async {
    final out = await service.perform(ScanMode.toWarehouse, 'PT9264428678');
    expect((out as ScanRejected).reason, ScanRejectReason.warehouseRequired);
  });

  test('network failure becomes ScanFailure with a transport error', () async {
    adapter.onGet(
      '/api/scan',
      (s) => s.throws(
        0,
        DioException(
          requestOptions: RequestOptions(path: '/api/scan'),
          type: DioExceptionType.connectionError,
        ),
      ),
      queryParameters: {'code': 'PT9264428678'},
    );
    final out = await service.perform(ScanMode.lookup, 'PT9264428678');
    expect((out as ScanFailure).error.isTransport, isTrue);
  });

  test('modes depend on roles', () {
    expect(modesFor(null), [ScanMode.lookup]);
  });
}
