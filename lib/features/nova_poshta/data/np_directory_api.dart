import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

part 'np_directory_api.freezed.dart';
part 'np_directory_api.g.dart';

/// A city, branch, locker or street of Nova Poshta: the `ref` goes into the shipment, the name is what people read.
@freezed
abstract class NpRef with _$NpRef {
  const factory NpRef({String? ref, String? name}) = _NpRef;

  factory NpRef.fromJson(Map<String, dynamic> json) => _$NpRefFromJson(json);
}

@freezed
abstract class NpCity with _$NpCity {
  const factory NpCity({String? ref, String? name, String? area}) = _NpCity;

  factory NpCity.fromJson(Map<String, dynamic> json) => _$NpCityFromJson(json);
}

@freezed
abstract class NpBranch with _$NpBranch {
  const factory NpBranch({
    String? ref,
    String? name,
    String? number,
    @Default(false) bool postomat,
  }) = _NpBranch;

  factory NpBranch.fromJson(Map<String, dynamic> json) =>
      _$NpBranchFromJson(json);
}

@freezed
abstract class NpStreet with _$NpStreet {
  const factory NpStreet({String? ref, String? name, String? type}) = _NpStreet;

  factory NpStreet.fromJson(Map<String, dynamic> json) =>
      _$NpStreetFromJson(json);
}

/// Live Nova Poshta directories, searched with the company's API key; up to 50 matches each.
class NpDirectoryApi {
  NpDirectoryApi(this._dio);

  final Dio _dio;

  Future<List<NpCity>> cities(String query) =>
      _list('/api/nova-poshta/cities', {'query': query}, NpCity.fromJson);

  Future<List<NpBranch>> branches({
    required String cityRef,
    required bool postomat,
    String query = '',
  }) => _list('/api/nova-poshta/warehouses', {
    'cityRef': cityRef,
    if (query.isNotEmpty) 'query': query,
    'type': postomat ? 'POSTOMAT' : 'WAREHOUSE',
  }, NpBranch.fromJson);

  Future<List<NpStreet>> streets({
    required String cityRef,
    required String query,
  }) => _list('/api/nova-poshta/streets', {
    'cityRef': cityRef,
    'query': query,
  }, NpStreet.fromJson);

  Future<List<T>> _list<T>(
    String path,
    Map<String, dynamic> params,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final res = await _dio.get<List<dynamic>>(path, queryParameters: params);
      return (res.data ?? [])
          .map((e) => fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final npDirectoryApiProvider = Provider<NpDirectoryApi>(
  (ref) => NpDirectoryApi(ref.watch(dioProvider)),
);

/// Search needs something to search for; two characters is where Nova Poshta starts being useful.
const npMinQuery = 2;

/// A failed lookup is shown as it is: the person retypes, and a silent retry loop would only hammer Nova Poshta.
Duration? _noRetry(int count, Object error) => null;

final npCitiesProvider = FutureProvider.autoDispose
    .family<List<NpCity>, String>(
      (ref, query) => query.trim().length < npMinQuery
          ? Future.value(const [])
          : ref.watch(npDirectoryApiProvider).cities(query.trim()),
      retry: _noRetry,
    );

/// Branches of a city are worth listing even before anything is typed.
final npBranchesProvider = FutureProvider.autoDispose
    .family<List<NpBranch>, ({String cityRef, bool postomat, String query})>(
      (ref, args) => ref
          .watch(npDirectoryApiProvider)
          .branches(
            cityRef: args.cityRef,
            postomat: args.postomat,
            query: args.query.trim(),
          ),
      retry: _noRetry,
    );

final npStreetsProvider = FutureProvider.autoDispose
    .family<List<NpStreet>, ({String cityRef, String query})>(
      (ref, args) => args.query.trim().length < npMinQuery
          ? Future.value(const [])
          : ref
                .watch(npDirectoryApiProvider)
                .streets(cityRef: args.cityRef, query: args.query.trim()),
      retry: _noRetry,
    );
