import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Body of every `POST /api/scan/*` call.
class ScanRequest {
  const ScanRequest({
    required this.code,
    this.manualInput = false,
    this.comment,
    this.tripId,
    this.paymentReceived,
    this.warehouseId,
  });

  final String code;
  final bool manualInput;
  final String? comment;
  final int? tripId;
  final bool? paymentReceived;
  final int? warehouseId;

  Map<String, dynamic> toJson() => {
    'code': code,
    'manualInput': manualInput,
    if (comment != null) 'comment': comment,
    if (tripId != null) 'tripId': tripId,
    if (paymentReceived != null) 'paymentReceived': paymentReceived,
    if (warehouseId != null) 'warehouseId': warehouseId,
  };
}

class ScanApi {
  ScanApi(this._dio);

  final Dio _dio;

  /// `GET /api/scan?code=` — TTN, parcel barcode or seat label; 404 when unknown.
  Future<Parcel> lookup(String code) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/scan',
        queryParameters: {'code': code},
      );
      return Parcel.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Parcel> receive(ScanRequest req) => _post('/api/scan/receive', req);

  Future<Parcel> load(ScanRequest req) => _post('/api/scan/load', req);

  Future<Parcel> deliver(ScanRequest req) => _post('/api/scan/deliver', req);

  Future<Parcel> toWarehouse(ScanRequest req) =>
      _post('/api/scan/to-warehouse', req);

  Future<Parcel> _post(String path, ScanRequest req) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        path,
        data: req.toJson(),
      );
      return Parcel.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final scanApiProvider = Provider<ScanApi>(
  (ref) => ScanApi(ref.watch(dioProvider)),
);
