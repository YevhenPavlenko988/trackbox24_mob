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
  /// `statuses` may hold several values (the parameter repeats); `open` = PLANNED + PREPARING + IN_PROGRESS.
  Future<Page<Trip>> list({
    List<TripStatus> statuses = const [],
    bool open = false,
    int page = 0,
    int size = 50,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/trips',
        queryParameters: {
          if (statuses.isNotEmpty)
            'status': statuses.map((s) => s.name).toList(),
          if (open) 'open': true,
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

  /// PLANNED -> PREPARING without a scan; the first loading scan does the same on its own.
  Future<Trip> startLoading(int id) =>
      _trip(() => _dio.post('/api/trips/$id/start-loading'));

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
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/trips/$id/parcels',
        queryParameters: {'size': 200, 'sort': 'id'},
      );
      return Page.fromJson(res.data!, Parcel.fromJson).content;
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<List<TripHistoryEntry>> history(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/trips/$id/history',
        queryParameters: {'size': 200, 'sort': 'changedAt,id'},
      );
      return Page.fromJson(res.data!, TripHistoryEntry.fromJson).content;
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

/// Trips in any of the given statuses (one request, the backend sorts by planned departure desc).
final tripsByStatusProvider = FutureProvider.autoDispose
    .family<List<Trip>, List<TripStatus>>(
      (ref, statuses) async =>
          (await ref.watch(tripApiProvider).list(statuses: statuses)).content,
    );

/// Refreshes every trip-related provider after an action.
void invalidateTrip(WidgetRef ref, int id) {
  ref
    ..invalidate(tripProvider(id))
    ..invalidate(tripParcelsProvider(id))
    ..invalidate(tripHistoryProvider(id))
    ..invalidate(tripsByStatusProvider);
}
