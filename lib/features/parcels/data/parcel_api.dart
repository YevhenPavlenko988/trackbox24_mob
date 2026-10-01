import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/page.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_history_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Sort that puts parcels whose paid storage at Nova Poshta starts soonest first.
const paidStorageSort = 'npPaidStorageFrom,asc';

class ParcelApi {
  ParcelApi(this._dio);

  final Dio _dio;

  Future<Page<Parcel>> list({
    ParcelStatus? status,
    int? representativeId,
    bool? needsEnrichment,
    String? query,
    String? sort,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/parcels',
        queryParameters: {
          if (status != null) 'status': status.name,
          if (representativeId != null) 'representativeId': representativeId,
          if (needsEnrichment != null) 'needsEnrichment': needsEnrichment,
          if (query != null && query.isNotEmpty) 'query': query,
          if (sort != null) 'sort': sort,
          'page': page,
          'size': size,
        },
      );
      return Page.fromJson(res.data!, Parcel.fromJson);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Parcel> get(int id) => _parcel(() => _dio.get('/api/parcels/$id'));

  Future<List<ParcelHistoryEntry>> history(int id) async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/parcels/$id/history');
      return (res.data ?? const [])
          .map(
            (e) =>
                ParcelHistoryEntry.fromJson((e as Map).cast<String, dynamic>()),
          )
          .toList();
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// `POST /api/parcels` — a representative becomes the parcel's representative automatically.
  Future<Parcel> create(Map<String, dynamic> body) =>
      _parcel(() => _dio.post('/api/parcels', data: body));

  /// `PUT /api/parcels/{id}` is partial: send only the fields that changed.
  Future<Parcel> update(int id, Map<String, dynamic> body) =>
      _parcel(() => _dio.put('/api/parcels/$id', data: body));

  Future<Parcel> refreshFromNp(int id) =>
      _parcel(() => _dio.post('/api/parcels/$id/nova-poshta/refresh'));

  Future<Parcel> _parcel(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return Parcel.fromJson((res.data as Map).cast<String, dynamic>());
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final parcelApiProvider = Provider<ParcelApi>(
  (ref) => ParcelApi(ref.watch(dioProvider)),
);

final parcelProvider = FutureProvider.autoDispose.family<Parcel, int>(
  (ref, id) => ref.watch(parcelApiProvider).get(id),
);

final parcelHistoryProvider = FutureProvider.autoDispose
    .family<List<ParcelHistoryEntry>, int>(
      (ref, id) => ref.watch(parcelApiProvider).history(id),
    );
