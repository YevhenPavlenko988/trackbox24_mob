import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

/// The bits of the user's own company the app acts on.
class CompanyInfo {
  const CompanyInfo({
    required this.id,
    required this.name,
    required this.photosEnabled,
    this.movesEnabled = false,
    this.parcelsEnabled = true,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) => CompanyInfo(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    photosEnabled: json['photosEnabled'] as bool? ?? false,
    movesEnabled: json['movesEnabled'] as bool? ?? false,
    parcelsEnabled: json['parcelsEnabled'] as bool? ?? true,
  );

  final int id;
  final String name;

  /// Switched on per company by the platform admin; without it photo upload answers 403.
  final bool photosEnabled;

  /// The moves module: without it a move already made is only shown — no scanning, no item photos of its own.
  final bool movesEnabled;

  /// The parcels module; off — the company only does moves: no new parcels, no Nova Poshta pickups.
  final bool parcelsEnabled;
}

class CompanyApi {
  CompanyApi(this._dio);

  final Dio _dio;

  Future<CompanyInfo> current() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/companies/current',
      );
      return CompanyInfo.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final companyApiProvider = Provider<CompanyApi>(
  (ref) => CompanyApi(ref.watch(dioProvider)),
);
