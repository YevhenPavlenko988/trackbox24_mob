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

  /// Scans taken offline, replayed in one request. Each result says whether that scan can leave the queue.
  Future<List<BatchScanResult>> batch(List<BatchScanItem> scans) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/scan/batch',
        data: {
          'scans': [for (final s in scans) s.toJson()],
        },
      );
      final results = res.data!['results'] as List<dynamic>? ?? const [];
      return [
        for (final r in results)
          BatchScanResult.fromJson(r as Map<String, dynamic>),
      ];
    } catch (e) {
      throw toApiException(e);
    }
  }

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

/// One offline scan in a batch; `id` makes a resend idempotent on the backend.
class BatchScanItem {
  const BatchScanItem({
    required this.id,
    required this.action,
    required this.code,
    required this.scannedAt,
    this.manualInput = false,
    this.comment,
    this.tripId,
    this.paymentReceived,
    this.warehouseId,
  });

  final String id;

  /// `RECEIVE` | `TO_WAREHOUSE` | `LOAD` | `DELIVER`.
  final String action;
  final String code;
  final DateTime scannedAt;
  final bool manualInput;
  final String? comment;
  final int? tripId;
  final bool? paymentReceived;
  final int? warehouseId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'action': action,
    'code': code,
    'scannedAt': scannedAt.toUtc().toIso8601String(),
    'manualInput': manualInput,
    if (comment != null) 'comment': comment,
    if (tripId != null) 'tripId': tripId,
    if (paymentReceived != null) 'paymentReceived': paymentReceived,
    if (warehouseId != null) 'warehouseId': warehouseId,
  };
}

/// What the backend did with one scan of the batch.
class BatchScanResult {
  const BatchScanResult({
    required this.id,
    required this.ok,
    required this.duplicate,
    this.parcel,
    this.status,
    this.detail,
  });

  factory BatchScanResult.fromJson(Map<String, dynamic> json) =>
      BatchScanResult(
        id: json['id'] as String? ?? '',
        ok: json['ok'] as bool? ?? false,
        duplicate: json['duplicate'] as bool? ?? false,
        parcel: json['parcel'] == null
            ? null
            : Parcel.fromJson(json['parcel'] as Map<String, dynamic>),
        status: json['status'] as int?,
        detail: json['detail'] as String?,
      );

  final String id;

  /// Applied now, or already applied earlier: either way the scan leaves the queue.
  final bool ok;
  final bool duplicate;
  final Parcel? parcel;
  final int? status;
  final String? detail;
}
