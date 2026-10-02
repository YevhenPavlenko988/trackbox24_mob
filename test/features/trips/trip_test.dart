import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/trip_logic.dart';

void main() {
  group('trip logic', () {
    const planned = Parcel(id: 1, plannedTripId: 7);
    const loadedInPlan = Parcel(
      id: 2,
      plannedTripId: 7,
      tripId: 7,
      seats: [
        Seat(seatNumber: 1, status: ParcelStatus.IN_CAR),
        Seat(seatNumber: 2, status: ParcelStatus.DELIVERED_TO_CLIENT),
      ],
    );
    const loadedOutside = Parcel(id: 3, tripId: 7, status: ParcelStatus.IN_CAR);
    const other = Parcel(id: 4, plannedTripId: 8);

    test('splits plan and fact', () {
      final s = splitTripParcels(7, const [
        planned,
        loadedInPlan,
        loadedOutside,
        other,
      ]);
      expect(s.planned.map((p) => p.id), [1]);
      expect(s.loaded.map((p) => p.id), [2, 3]);
    });

    test('outside plan', () {
      expect(isOutsidePlan(7, loadedOutside), isTrue);
      expect(isOutsidePlan(7, loadedInPlan), isFalse);
    });

    test('seat progress counts delivered as loaded', () {
      final p = seatProgress(const [loadedInPlan, loadedOutside]);
      expect(p.total, 3);
      expect(p.loaded, 3);
      expect(p.delivered, 1);
    });

    test('trip helpers', () {
      const t = Trip(
        id: 1,
        status: TripStatus.PREPARING,
        carId: 1,
        driverId: 2,
        origin: 'Київ',
        destination: 'Львів',
      );
      expect(t.canDepart, isTrue);
      expect(t.route, 'Київ → Львів');
      expect(const Trip(id: 2, status: TripStatus.PLANNED).canDepart, isFalse);
      expect(
        const Trip(id: 3, status: TripStatus.IN_PROGRESS).acceptsLoading,
        isFalse,
      );
    });
  });

  group('TripApi', () {
    late DioAdapter adapter;
    late TripApi api;

    setUp(() {
      final dio = createDio(
        baseUrl: 'http://test',
        auth: AuthInterceptor(
          readToken: () async => 'jwt',
          onUnauthorized: () async {},
        ),
      );
      adapter = DioAdapter(dio: dio);
      api = TripApi(dio);
    });

    test('complete 409 exposes undeliveredParcels', () async {
      adapter.onPost(
        '/api/trips/5/complete',
        (s) => s.reply(409, {
          'title': 'Parcels left in the car',
          'status': 409,
          'undeliveredParcels': [
            {'id': 11, 'barcode': 'PT1111111111', 'status': 'IN_CAR'},
          ],
        }),
        data: {'endOdometerKm': 120},
      );
      try {
        await api.complete(5, endOdometerKm: 120);
        fail('expected 409');
      } on ApiException catch (e) {
        expect(e.isConflict, isTrue);
        final left = (e.extensions['undeliveredParcels'] as List).map(
          (x) => Parcel.fromJson((x as Map).cast<String, dynamic>()),
        );
        expect(left.first.barcode, 'PT1111111111');
      }
    });

    test('create sends UTC instant and omits empty strings', () async {
      adapter.onPost(
        '/api/trips',
        (s) => s.reply(200, {'id': 9, 'status': 'PLANNED'}),
        data: {
          'plannedDepartureAt': '2026-10-02T09:00:00.000Z',
          'origin': 'Київ',
        },
      );
      final t = await api.create(
        plannedDepartureAt: DateTime.utc(2026, 10, 2, 9),
        origin: 'Київ',
        destination: '',
      );
      expect(t.id, 9);
      expect(t.status, TripStatus.PLANNED);
    });

    test('list filters by status', () async {
      adapter.onGet(
        '/api/trips',
        (s) => s.reply(200, {
          'content': [
            {'id': 1, 'status': 'IN_PROGRESS'},
          ],
          'page': {
            'size': 50,
            'number': 0,
            'totalElements': 1,
            'totalPages': 1,
          },
        }),
        queryParameters: {
          'status': ['PREPARING', 'IN_PROGRESS'],
          'sort': 'plannedDepartureAt,desc',
          'page': 0,
          'size': 50,
        },
      );
      final page = await api.list(
        statuses: [TripStatus.PREPARING, TripStatus.IN_PROGRESS],
      );
      expect(page.content.single.status, TripStatus.IN_PROGRESS);
    });
  });
}
