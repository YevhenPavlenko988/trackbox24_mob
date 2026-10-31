import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/page.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_history_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/data/seat_check.dart';

/// Sort that puts parcels whose paid storage at Nova Poshta starts soonest first.
const paidStorageSort = 'npPaidStorageFrom,asc';

class ParcelApi {
  ParcelApi(this._dio);

  final Dio _dio;

  /// `statuses` repeats the `status` parameter: the backend returns parcels in any of them.
  Future<Page<Parcel>> list({
    List<ParcelStatus> statuses = const [],
    int? representativeId,
    bool? needsEnrichment,
    bool mine = false,
    String? query,
    String? sort,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/parcels',
        queryParameters: {
          if (statuses.isNotEmpty)
            'status': statuses.map((s) => s.name).toList(),
          if (representativeId != null) 'representativeId': representativeId,
          if (needsEnrichment != null) 'needsEnrichment': needsEnrichment,
          if (mine) 'mine': true,
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
      // Paged on the backend; a parcel never has this many events.
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/parcels/$id/history',
        queryParameters: {'size': 200, 'sort': 'changedAt,id'},
      );
      return Page.fromJson(res.data!, ParcelHistoryEntry.fromJson).content;
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

  /// `PUT /api/parcels/{id}/np-shipment` replaces all the shipment fields; a created waybill locks them.
  Future<Parcel> updateNpShipment(int id, Map<String, dynamic> body) =>
      _parcel(() => _dio.put('/api/parcels/$id/np-shipment', data: body));

  /// Creates our Nova Poshta waybill from the shipment and the parcel (driver or manager). A 400 lists what is
  /// still missing, or quotes Nova Poshta's refusal.
  Future<Parcel> createNpWaybill(int id) =>
      _parcel(() => _dio.post('/api/parcels/$id/np-shipment/waybill'));

  /// Deletes the waybill in Nova Poshta while it has not taken the parcel; the recipient data stays.
  Future<Parcel> deleteNpWaybill(int id) =>
      _parcel(() => _dio.delete('/api/parcels/$id/np-shipment/waybill'));

  Future<Parcel> refreshFromNp(int id) =>
      _parcel(() => _dio.post('/api/parcels/$id/nova-poshta/refresh'));

  /// What a move's item is.
  Future<Parcel> describeSeat(int id, int seatNumber, String description) =>
      _parcel(
        () => _dio.put(
          '/api/parcels/$id/seats/$seatNumber',
          data: {'description': description},
        ),
      );

  /// The move's register as an XLSX file: the header (from, to, status) and a row per item.
  Future<List<int>> seatRegister(int id) async {
    try {
      final res = await _dio.get<List<int>>(
        '/api/parcels/$id/seats/register.xlsx',
        options: Options(responseType: ResponseType.bytes),
      );
      return res.data!;
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Forgotten items of a move, one description each; they get the next numbers.
  Future<Parcel> addSeats(int id, List<String> descriptions) => _parcel(
    () => _dio.post(
      '/api/parcels/$id/seats',
      data: {'descriptions': descriptions},
    ),
  );

  /// Chosen items onto a warehouse or handed over without scanning; [comment] is required when items stay behind.
  Future<Parcel> moveSeats(
    int id,
    List<int> seatNumbers, {
    required bool deliver,
    int? warehouseId,
    String? comment,
  }) => _parcel(
    () => _dio.post(
      '/api/parcels/$id/seats/move',
      data: {
        'seatNumbers': seatNumbers,
        'target': deliver ? 'DELIVER' : 'WAREHOUSE',
        'warehouseId': ?warehouseId,
        'comment': ?comment,
      },
    ),
  );

  /// Which items are scanned for the stage and which are missing; changes nothing.
  Future<SeatCheck> seatCheck(
    int id,
    SeatCheckStage stage, {
    int? warehouseId,
  }) => _check(
    () => _dio.get(
      '/api/parcels/$id/seats/check',
      queryParameters: {'stage': stage.name, 'warehouseId': ?warehouseId},
    ),
  );

  /// «Закінчили сканування»: the result goes to the history; a hand-over with items missing needs [comment].
  Future<SeatCheck> finishSeatCheck(
    int id,
    SeatCheckStage stage, {
    int? warehouseId,
    String? comment,
  }) => _check(
    () => _dio.post(
      '/api/parcels/$id/seats/check',
      data: {
        'stage': stage.name,
        'warehouseId': ?warehouseId,
        'comment': ?comment,
      },
    ),
  );

  Future<SeatCheck> _check(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return SeatCheck.fromJson((res.data as Map).cast<String, dynamic>());
    } catch (e) {
      throw toApiException(e);
    }
  }

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
