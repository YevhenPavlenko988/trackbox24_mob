// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trip _$TripFromJson(Map<String, dynamic> json) => _Trip(
  id: (json['id'] as num).toInt(),
  number: (json['number'] as num?)?.toInt(),
  routeId: (json['routeId'] as num?)?.toInt(),
  legNumber: (json['legNumber'] as num?)?.toInt(),
  status: $enumDecodeNullable(
    _$TripStatusEnumMap,
    json['status'],
    unknownValue: TripStatus.unknown,
  ),
  carId: (json['carId'] as num?)?.toInt(),
  carPlateNumber: json['carPlateNumber'] as String?,
  driverId: (json['driverId'] as num?)?.toInt(),
  driverName: json['driverName'] as String?,
  coDriverId: (json['coDriverId'] as num?)?.toInt(),
  coDriverName: json['coDriverName'] as String?,
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
  plannedCount: (json['plannedCount'] as num?)?.toInt() ?? 0,
  loadedCount: (json['loadedCount'] as num?)?.toInt() ?? 0,
  deliveredCount: (json['deliveredCount'] as num?)?.toInt() ?? 0,
  payments: json['payments'] == null
      ? null
      : TripPayments.fromJson(json['payments'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TripToJson(_Trip instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'routeId': instance.routeId,
  'legNumber': instance.legNumber,
  'status': _$TripStatusEnumMap[instance.status],
  'carId': instance.carId,
  'carPlateNumber': instance.carPlateNumber,
  'driverId': instance.driverId,
  'driverName': instance.driverName,
  'coDriverId': instance.coDriverId,
  'coDriverName': instance.coDriverName,
  'plannedDepartureAt': instance.plannedDepartureAt?.toIso8601String(),
  'plannedArrivalAt': instance.plannedArrivalAt?.toIso8601String(),
  'origin': instance.origin,
  'destination': instance.destination,
  'notes': instance.notes,
  'departedAt': instance.departedAt?.toIso8601String(),
  'arrivedAt': instance.arrivedAt?.toIso8601String(),
  'startOdometerKm': instance.startOdometerKm,
  'endOdometerKm': instance.endOdometerKm,
  'plannedCount': instance.plannedCount,
  'loadedCount': instance.loadedCount,
  'deliveredCount': instance.deliveredCount,
  'payments': instance.payments,
};

const _$TripStatusEnumMap = {
  TripStatus.PLANNED: 'PLANNED',
  TripStatus.PREPARING: 'PREPARING',
  TripStatus.IN_PROGRESS: 'IN_PROGRESS',
  TripStatus.COMPLETED: 'COMPLETED',
  TripStatus.CANCELLED: 'CANCELLED',
  TripStatus.unknown: 'unknown',
};

_TripPayments _$TripPaymentsFromJson(Map<String, dynamic> json) =>
    _TripPayments(
      received:
          (json['received'] as List<dynamic>?)
              ?.map((e) => TripPaymentLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notReceived:
          (json['notReceived'] as List<dynamic>?)
              ?.map((e) => TripPaymentLine.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TripPaymentsToJson(_TripPayments instance) =>
    <String, dynamic>{
      'received': instance.received,
      'notReceived': instance.notReceived,
    };

_TripPaymentLine _$TripPaymentLineFromJson(Map<String, dynamic> json) =>
    _TripPaymentLine(
      currency: json['currency'] as String?,
      method: $enumDecodeNullable(
        _$PaymentMethodEnumMap,
        json['method'],
        unknownValue: PaymentMethod.unknown,
      ),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      parcels: (json['parcels'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$TripPaymentLineToJson(_TripPaymentLine instance) =>
    <String, dynamic>{
      'currency': instance.currency,
      'method': _$PaymentMethodEnumMap[instance.method],
      'amount': instance.amount,
      'parcels': instance.parcels,
    };

const _$PaymentMethodEnumMap = {
  PaymentMethod.CASH: 'CASH',
  PaymentMethod.UA_CARD: 'UA_CARD',
  PaymentMethod.FOREIGN_CARD: 'FOREIGN_CARD',
  PaymentMethod.unknown: 'unknown',
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
  TripEvent.DELETED: 'DELETED',
  TripEvent.RESTORED: 'RESTORED',
  TripEvent.unknown: 'unknown',
};
