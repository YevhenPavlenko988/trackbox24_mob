import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/page.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

class TripApi {
  TripApi(this._dio);

  final Dio _dio;

  /// A pure DRIVER sees only own trips; a REPRESENTATIVE sees the whole company's.
  Future<Page<Trip>> list({
    TripStatus? status,
    int page = 0,
    int size = 50,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/trips',
        queryParameters: {
          if (status != null) 'status': status.name,
          'sort': 'plannedDepartureAt,desc',
          'page': page,
          'size': size,
        },
      );
      return Page.fromJson(res.data!, Trip.fromJson);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Trip> get(int id) => _trip(() => _dio.get('/api/trips/$id'));

  /// Driver: car defaults to the one assigned to them, driver is always themselves.
  Future<Trip> create({
    DateTime? plannedDepartureAt,
    DateTime? plannedArrivalAt,
    String? origin,
    String? destination,
    String? notes,
  }) => _trip(
    () => _dio.post(
      '/api/trips',
      data: {
        if (plannedDepartureAt != null)
          'plannedDepartureAt': plannedDepartureAt.toUtc().toIso8601String(),
        if (plannedArrivalAt != null)
          'plannedArrivalAt': plannedArrivalAt.toUtc().toIso8601String(),
        if (origin != null && origin.isNotEmpty) 'origin': origin,
        if (destination != null && destination.isNotEmpty)
          'destination': destination,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    ),
  );

  Future<Trip> depart(int id, {int? startOdometerKm}) => _trip(
    () => _dio.post(
      '/api/trips/$id/depart',
      data: {if (startOdometerKm != null) 'startOdometerKm': startOdometerKm},
    ),
  );

  /// Throws an `ApiException` with `extensions['undeliveredParcels']` on 409.
  Future<Trip> complete(int id, {int? endOdometerKm, String? notes}) => _trip(
    () => _dio.post(
      '/api/trips/$id/complete',
      data: {
        if (endOdometerKm != null) 'endOdometerKm': endOdometerKm,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      },
    ),
  );

  Future<List<Parcel>> parcels(int id) async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/trips/$id/parcels');
      return (res.data ?? const [])
          .map((e) => Parcel.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<List<TripHistoryEntry>> history(int id) async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/trips/$id/history');
      return (res.data ?? const [])
          .map(
            (e) =>
                TripHistoryEntry.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList();
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Trip> _trip(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return Trip.fromJson((res.data as Map).cast<String, dynamic>());
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final tripApiProvider = Provider<TripApi>(
  (ref) => TripApi(ref.watch(dioProvider)),
);

final tripProvider = FutureProvider.autoDispose.family<Trip, int>(
  (ref, id) => ref.watch(tripApiProvider).get(id),
);

final tripParcelsProvider = FutureProvider.autoDispose
    .family<List<Parcel>, int>(
      (ref, id) => ref.watch(tripApiProvider).parcels(id),
    );

final tripHistoryProvider = FutureProvider.autoDispose
    .family<List<TripHistoryEntry>, int>(
      (ref, id) => ref.watch(tripApiProvider).history(id),
    );

/// Trips in any of the given statuses (one request per status), newest planned departure first.
final tripsByStatusProvider = FutureProvider.autoDispose
    .family<List<Trip>, List<TripStatus>>((ref, statuses) async {
      final api = ref.watch(tripApiProvider);
      final pages = await Future.wait(statuses.map((s) => api.list(status: s)));
      final all = [for (final p in pages) ...p.content]
        ..sort(
          (a, b) => (b.plannedDepartureAt ?? DateTime(0)).compareTo(
            a.plannedDepartureAt ?? DateTime(0),
          ),
        );
      return all;
    });

/// Refreshes every trip-related provider after an action.
void invalidateTrip(WidgetRef ref, int id) {
  ref
    ..invalidate(tripProvider(id))
    ..invalidate(tripParcelsProvider(id))
    ..invalidate(tripHistoryProvider(id))
    ..invalidate(tripsByStatusProvider);
}
