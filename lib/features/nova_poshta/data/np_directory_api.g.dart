// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'np_directory_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NpRef _$NpRefFromJson(Map<String, dynamic> json) =>
    _NpRef(ref: json['ref'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$NpRefToJson(_NpRef instance) => <String, dynamic>{
  'ref': instance.ref,
  'name': instance.name,
};

_NpCity _$NpCityFromJson(Map<String, dynamic> json) => _NpCity(
  ref: json['ref'] as String?,
  name: json['name'] as String?,
  area: json['area'] as String?,
);

Map<String, dynamic> _$NpCityToJson(_NpCity instance) => <String, dynamic>{
  'ref': instance.ref,
  'name': instance.name,
  'area': instance.area,
};

_NpBranch _$NpBranchFromJson(Map<String, dynamic> json) => _NpBranch(
  ref: json['ref'] as String?,
  name: json['name'] as String?,
  number: json['number'] as String?,
  postomat: json['postomat'] as bool? ?? false,
);

Map<String, dynamic> _$NpBranchToJson(_NpBranch instance) => <String, dynamic>{
  'ref': instance.ref,
  'name': instance.name,
  'number': instance.number,
  'postomat': instance.postomat,
};

_NpStreet _$NpStreetFromJson(Map<String, dynamic> json) => _NpStreet(
  ref: json['ref'] as String?,
  name: json['name'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$NpStreetToJson(_NpStreet instance) => <String, dynamic>{
  'ref': instance.ref,
  'name': instance.name,
  'type': instance.type,
};
