// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: (json['id'] as num).toInt(),
  status: $enumDecodeNullable(
    _$TripStatusEnumMap,
    json['status'],
    unknownValue: TripStatus.unknown,
  ),
  carId: (json['carId'] as num?)?.toInt(),
  carPlateNumber: json['carPlateNumber'] as String?,
  driverId: (json['driverId'] as num?)?.toInt(),
  driverName: json['driverName'] as String?,
  plannedDepartureAt: json['plannedDepartureAt'] == null
      ? null
      : DateTime.parse(json['plannedDepartureAt'] as String),
  plannedArrivalAt: json['plannedArrivalAt'] == null
      ? null
      : DateTime.parse(json['plannedArrivalAt'] as String),
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  notes: json['notes'] as String?,
  departedAt: json['departedAt'] == null
      ? null
      : DateTime.parse(json['departedAt'] as String),
  arrivedAt: json['arrivedAt'] == null
      ? null
      : DateTime.parse(json['arrivedAt'] as String),
  startOdometerKm: (json['startOdometerKm'] as num?)?.toInt(),
  endOdometerKm: (json['endOdometerKm'] as num?)?.toInt(),
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'status': _$TripStatusEnumMap[instance.status],
  'carId': instance.carId,
  'carPlateNumber': instance.carPlateNumber,
  'driverId': instance.driverId,
  'driverName': instance.driverName,
  'plannedDepartureAt': instance.plannedDepartureAt?.toIso8601String(),
  'plannedArrivalAt': instance.plannedArrivalAt?.toIso8601String(),
  'origin': instance.origin,
  'destination': instance.destination,
  'notes': instance.notes,
  'departedAt': instance.departedAt?.toIso8601String(),
  'arrivedAt': instance.arrivedAt?.toIso8601String(),
  'startOdometerKm': instance.startOdometerKm,
  'endOdometerKm': instance.endOdometerKm,
};

const _$TripStatusEnumMap = {
  TripStatus.PLANNED: 'PLANNED',
  TripStatus.PREPARING: 'PREPARING',
  TripStatus.IN_PROGRESS: 'IN_PROGRESS',
  TripStatus.COMPLETED: 'COMPLETED',
  TripStatus.CANCELLED: 'CANCELLED',
  TripStatus.unknown: 'unknown',
};

_TripHistoryEntry _$TripHistoryEntryFromJson(Map<String, dynamic> json) =>
    _TripHistoryEntry(
      id: (json['id'] as num).toInt(),
      event: $enumDecodeNullable(
        _$TripEventEnumMap,
        json['event'],
        unknownValue: TripEvent.unknown,
      ),
      previousStatus: $enumDecodeNullable(
        _$TripStatusEnumMap,
        json['previousStatus'],
        unknownValue: TripStatus.unknown,
      ),
      status: $enumDecodeNullable(
        _$TripStatusEnumMap,
        json['status'],
        unknownValue: TripStatus.unknown,
      ),
      parcelId: (json['parcelId'] as num?)?.toInt(),
      parcelBarcode: json['parcelBarcode'] as String?,
      changedById: (json['changedById'] as num?)?.toInt(),
      changedByName: json['changedByName'] as String?,
      changedAt: json['changedAt'] == null
          ? null
          : DateTime.parse(json['changedAt'] as String),
      comment: json['comment'] as String?,
    );

Map<String, dynamic> _$TripHistoryEntryToJson(_TripHistoryEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event': _$TripEventEnumMap[instance.event],
      'previousStatus': _$TripStatusEnumMap[instance.previousStatus],
      'status': _$TripStatusEnumMap[instance.status],
      'parcelId': instance.parcelId,
      'parcelBarcode': instance.parcelBarcode,
      'changedById': instance.changedById,
      'changedByName': instance.changedByName,
      'changedAt': instance.changedAt?.toIso8601String(),
      'comment': instance.comment,
    };

const _$TripEventEnumMap = {
  TripEvent.CREATED: 'CREATED',
  TripEvent.UPDATED: 'UPDATED',
  TripEvent.STATUS_CHANGED: 'STATUS_CHANGED',
  TripEvent.PARCEL_PLANNED: 'PARCEL_PLANNED',
  TripEvent.PARCEL_UNPLANNED: 'PARCEL_UNPLANNED',
  TripEvent.PARCEL_LOADED: 'PARCEL_LOADED',
  TripEvent.PARCEL_DELIVERED: 'PARCEL_DELIVERED',
  TripEvent.PARCEL_UNLOADED: 'PARCEL_UNLOADED',
  TripEvent.unknown: 'unknown',
};
