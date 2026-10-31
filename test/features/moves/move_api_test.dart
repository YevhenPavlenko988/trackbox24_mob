import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';

void main() {
  late DioAdapter adapter;
  late ParcelApi api;

  setUp(() {
    final dio = createDio(
      baseUrl: 'http://test',
      auth: AuthInterceptor(
        readToken: () async => 'jwt',
        onUnauthorized: () async {},
      ),
    );
    adapter = DioAdapter(dio: dio);
    api = ParcelApi(dio);
  });

  test('adds forgotten items to a move', () async {
    adapter.onPost(
      '/api/parcels/7/seats',
      (s) => s.reply(200, {
        'id': 7,
        'kind': 'MOVE',
        'seats': [
          {'seatNumber': 1},
          {'seatNumber': 2, 'description': 'Коробка — книги'},
        ],
      }),
      data: {
        'descriptions': ['Коробка — книги'],
      },
    );
    final move = await api.addSeats(7, ['Коробка — книги']);
    expect(move.seats.last.seatNumber, 2);
  });

  test('moves chosen items by hand', () async {
    adapter.onPost(
      '/api/parcels/7/seats/move',
      (s) => s.reply(200, {'id': 7, 'kind': 'MOVE'}),
      data: {
        'seatNumbers': [1, 3],
        'target': 'WAREHOUSE',
        'warehouseId': 2,
      },
    );
    final move = await api.moveSeats(7, [1, 3], deliver: false, warehouseId: 2);
    expect(move.id, 7);
  });

  test('the register comes as the bytes of the file', () async {
    adapter.onGet(
      '/api/parcels/7/seats/register.xlsx',
      (s) => s.reply(200, 'PK-register'),
    );
    // the body is handed over untouched, byte for byte (the mock wraps it as JSON text)
    expect(utf8.decode(await api.seatRegister(7)), contains('PK-register'));
  });
}
