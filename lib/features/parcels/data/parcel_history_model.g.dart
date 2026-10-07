// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParcelHistoryEntry _$ParcelHistoryEntryFromJson(Map<String, dynamic> json) =>
    _ParcelHistoryEntry(
      id: (json['id'] as num).toInt(),
      seatNumber: (json['seatNumber'] as num?)?.toInt(),
      previousStatus: $enumDecodeNullable(
        _$ParcelStatusEnumMap,
        json['previousStatus'],
        unknownValue: ParcelStatus.unknown,
      ),
      status: $enumDecodeNullable(
        _$ParcelStatusEnumMap,
        json['status'],
        unknownValue: ParcelStatus.unknown,
      ),
      warehouseId: (json['warehouseId'] as num?)?.toInt(),
      warehouseName: json['warehouseName'] as String?,
      npStatusCode: json['npStatusCode'] as String?,
      npStatusText: json['npStatusText'] as String?,
      source: $enumDecodeNullable(
        _$HistorySourceEnumMap,
        json['source'],
        unknownValue: HistorySource.unknown,
      ),
      changedById: (json['changedById'] as num?)?.toInt(),
      changedByName: json['changedByName'] as String?,
      changedAt: json['changedAt'] == null
          ? null
          : DateTime.parse(json['changedAt'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$ParcelHistoryEntryToJson(_ParcelHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seatNumber': instance.seatNumber,
      'previousStatus': _$ParcelStatusEnumMap[instance.previousStatus],
      'status': _$ParcelStatusEnumMap[instance.status],
      'warehouseId': instance.warehouseId,
      'warehouseName': instance.warehouseName,
      'npStatusCode': instance.npStatusCode,
      'npStatusText': instance.npStatusText,
      'source': _$HistorySourceEnumMap[instance.source],
      'changedById': instance.changedById,
      'changedByName': instance.changedByName,
      'changedAt': instance.changedAt?.toIso8601String(),
      'comment': instance.comment,
    };

const _$ParcelStatusEnumMap = {
  ParcelStatus.IN_NOVA_POSHTA: 'IN_NOVA_POSHTA',
  ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA: 'PICKED_UP_FROM_NOVA_POSHTA',
  ParcelStatus.RECEIVED_BY_REPRESENTATIVE: 'RECEIVED_BY_REPRESENTATIVE',
  ParcelStatus.AT_WAREHOUSE: 'AT_WAREHOUSE',
  ParcelStatus.IN_CAR: 'IN_CAR',
  ParcelStatus.DELIVERED_TO_CLIENT: 'DELIVERED_TO_CLIENT',
  ParcelStatus.CANCELLED: 'CANCELLED',
  ParcelStatus.unknown: 'unknown',
};

const _$HistorySourceEnumMap = {
  HistorySource.SCAN: 'SCAN',
  HistorySource.MANUAL: 'MANUAL',
  HistorySource.NOVA_POSHTA: 'NOVA_POSHTA',
  HistorySource.SYSTEM: 'SYSTEM',
  HistorySource.unknown: 'unknown',
};
