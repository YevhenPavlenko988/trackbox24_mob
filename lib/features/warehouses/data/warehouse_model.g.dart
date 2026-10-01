// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warehouse_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Warehouse _$WarehouseFromJson(Map<String, dynamic> json) => _Warehouse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$WarehouseToJson(_Warehouse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'notes': instance.notes,
      'active': instance.active,
    };
