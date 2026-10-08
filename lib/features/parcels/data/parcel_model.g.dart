// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Seat _$SeatFromJson(Map<String, dynamic> json) => _Seat(
  seatNumber: (json['seatNumber'] as num).toInt(),
  barcode: json['barcode'] as String?,
  status: $enumDecodeNullable(
    _$ParcelStatusEnumMap,
    json['status'],
    unknownValue: ParcelStatus.unknown,
  ),
  statusChangedAt: json['statusChangedAt'] == null
      ? null
      : DateTime.parse(json['statusChangedAt'] as String),
  statusChangedBy: json['statusChangedBy'] as String?,
  warehouseId: (json['warehouseId'] as num?)?.toInt(),
  warehouseName: json['warehouseName'] as String?,
);

Map<String, dynamic> _$SeatToJson(_Seat instance) => <String, dynamic>{
  'seatNumber': instance.seatNumber,
  'barcode': instance.barcode,
  'status': _$ParcelStatusEnumMap[instance.status],
  'statusChangedAt': instance.statusChangedAt?.toIso8601String(),
  'statusChangedBy': instance.statusChangedBy,
  'warehouseId': instance.warehouseId,
  'warehouseName': instance.warehouseName,
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

_Parcel _$ParcelFromJson(Map<String, dynamic> json) => _Parcel(
  id: (json['id'] as num).toInt(),
  barcode: json['barcode'] as String?,
  source: $enumDecodeNullable(
    _$ParcelSourceEnumMap,
    json['source'],
    unknownValue: ParcelSource.unknown,
  ),
  status: $enumDecodeNullable(
    _$ParcelStatusEnumMap,
    json['status'],
    unknownValue: ParcelStatus.unknown,
  ),
  statusChangedAt: json['statusChangedAt'] == null
      ? null
      : DateTime.parse(json['statusChangedAt'] as String),
  statusChangedBy: json['statusChangedBy'] as String?,
  needsEnrichment: json['needsEnrichment'] as bool? ?? false,
  representativeId: (json['representativeId'] as num?)?.toInt(),
  representativeName: json['representativeName'] as String?,
  clientId: (json['clientId'] as num?)?.toInt(),
  clientName: json['clientName'] as String?,
  clientPhone: json['clientPhone'] as String?,
  clientCity: json['clientCity'] as String?,
  clientAddress: json['clientAddress'] as String?,
  description: json['description'] as String?,
  weightKg: (json['weightKg'] as num?)?.toDouble(),
  seatsAmount: (json['seatsAmount'] as num?)?.toInt(),
  lengthCm: (json['lengthCm'] as num?)?.toDouble(),
  widthCm: (json['widthCm'] as num?)?.toDouble(),
  heightCm: (json['heightCm'] as num?)?.toDouble(),
  deliveryCity: json['deliveryCity'] as String?,
  declaredValue: (json['declaredValue'] as num?)?.toDouble(),
  deliveryPrice: (json['deliveryPrice'] as num?)?.toDouble(),
  deliveryPriceCurrency: json['deliveryPriceCurrency'] as String?,
  paymentStatus: $enumDecodeNullable(
    _$PaymentStatusEnumMap,
    json['paymentStatus'],
    unknownValue: PaymentStatus.unknown,
  ),
  paidAt: json['paidAt'] == null
      ? null
      : DateTime.parse(json['paidAt'] as String),
  paidBy: json['paidBy'] as String?,
  senderName: json['senderName'] as String?,
  senderPhone: json['senderPhone'] as String?,
  senderCity: json['senderCity'] as String?,
  notes: json['notes'] as String?,
  npTtn: json['npTtn'] as String?,
  npPreviousTtn: json['npPreviousTtn'] as String?,
  channel: $enumDecodeNullable(
    _$ChannelEnumMap,
    json['channel'],
    unknownValue: Channel.unknown,
  ),
  channelDetails: json['channelDetails'] as String?,
  npStatusCode: json['npStatusCode'] as String?,
  npState: $enumDecodeNullable(
    _$NpStateEnumMap,
    json['npState'],
    unknownValue: NpState.unknown,
  ),
  npStatusText: json['npStatusText'] as String?,
  npStatusUpdatedAt: json['npStatusUpdatedAt'] == null
      ? null
      : DateTime.parse(json['npStatusUpdatedAt'] as String),
  npRecipientWarehouse: json['npRecipientWarehouse'] as String?,
  npScheduledDeliveryAt: json['npScheduledDeliveryAt'] == null
      ? null
      : DateTime.parse(json['npScheduledDeliveryAt'] as String),
  npArrivedAt: json['npArrivedAt'] == null
      ? null
      : DateTime.parse(json['npArrivedAt'] as String),
  npPaidStorageFrom: json['npPaidStorageFrom'] == null
      ? null
      : DateTime.parse(json['npPaidStorageFrom'] as String),
  npDeliveryCost: (json['npDeliveryCost'] as num?)?.toDouble(),
  npCodAmount: (json['npCodAmount'] as num?)?.toDouble(),
  npPayerType: json['npPayerType'] as String?,
  npPaymentMethod: json['npPaymentMethod'] as String?,
  npPaymentStatus: json['npPaymentStatus'] as String?,
  npDeliveryAmountDue: (json['npDeliveryAmountDue'] as num?)?.toDouble(),
  npPreviousDeliveryCost: (json['npPreviousDeliveryCost'] as num?)?.toDouble(),
  npAmountToPay: (json['npAmountToPay'] as num?)?.toDouble(),
  npDeliveryToPay: (json['npDeliveryToPay'] as num?)?.toDouble(),
  npPreviousDeliveryToPay: (json['npPreviousDeliveryToPay'] as num?)
      ?.toDouble(),
  npCodToPay: (json['npCodToPay'] as num?)?.toDouble(),
  npVolumeWeight: (json['npVolumeWeight'] as num?)?.toDouble(),
  seats:
      (json['seats'] as List<dynamic>?)
          ?.map((e) => Seat.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  warehouseId: (json['warehouseId'] as num?)?.toInt(),
  warehouseName: json['warehouseName'] as String?,
  plannedTripId: (json['plannedTripId'] as num?)?.toInt(),
  tripId: (json['tripId'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ParcelToJson(_Parcel instance) => <String, dynamic>{
  'id': instance.id,
  'barcode': instance.barcode,
  'source': _$ParcelSourceEnumMap[instance.source],
  'status': _$ParcelStatusEnumMap[instance.status],
  'statusChangedAt': instance.statusChangedAt?.toIso8601String(),
  'statusChangedBy': instance.statusChangedBy,
  'needsEnrichment': instance.needsEnrichment,
  'representativeId': instance.representativeId,
  'representativeName': instance.representativeName,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'clientPhone': instance.clientPhone,
  'clientCity': instance.clientCity,
  'clientAddress': instance.clientAddress,
  'description': instance.description,
  'weightKg': instance.weightKg,
  'seatsAmount': instance.seatsAmount,
  'lengthCm': instance.lengthCm,
  'widthCm': instance.widthCm,
  'heightCm': instance.heightCm,
  'deliveryCity': instance.deliveryCity,
  'declaredValue': instance.declaredValue,
  'deliveryPrice': instance.deliveryPrice,
  'deliveryPriceCurrency': instance.deliveryPriceCurrency,
  'paymentStatus': _$PaymentStatusEnumMap[instance.paymentStatus],
  'paidAt': instance.paidAt?.toIso8601String(),
  'paidBy': instance.paidBy,
  'senderName': instance.senderName,
  'senderPhone': instance.senderPhone,
  'senderCity': instance.senderCity,
  'notes': instance.notes,
  'npTtn': instance.npTtn,
  'npPreviousTtn': instance.npPreviousTtn,
  'channel': _$ChannelEnumMap[instance.channel],
  'channelDetails': instance.channelDetails,
  'npStatusCode': instance.npStatusCode,
  'npState': _$NpStateEnumMap[instance.npState],
  'npStatusText': instance.npStatusText,
  'npStatusUpdatedAt': instance.npStatusUpdatedAt?.toIso8601String(),
  'npRecipientWarehouse': instance.npRecipientWarehouse,
  'npScheduledDeliveryAt': instance.npScheduledDeliveryAt?.toIso8601String(),
  'npArrivedAt': instance.npArrivedAt?.toIso8601String(),
  'npPaidStorageFrom': instance.npPaidStorageFrom?.toIso8601String(),
  'npDeliveryCost': instance.npDeliveryCost,
  'npCodAmount': instance.npCodAmount,
  'npPayerType': instance.npPayerType,
  'npPaymentMethod': instance.npPaymentMethod,
  'npPaymentStatus': instance.npPaymentStatus,
  'npDeliveryAmountDue': instance.npDeliveryAmountDue,
  'npPreviousDeliveryCost': instance.npPreviousDeliveryCost,
  'npAmountToPay': instance.npAmountToPay,
  'npDeliveryToPay': instance.npDeliveryToPay,
  'npPreviousDeliveryToPay': instance.npPreviousDeliveryToPay,
  'npCodToPay': instance.npCodToPay,
  'npVolumeWeight': instance.npVolumeWeight,
  'seats': instance.seats,
  'warehouseId': instance.warehouseId,
  'warehouseName': instance.warehouseName,
  'plannedTripId': instance.plannedTripId,
  'tripId': instance.tripId,
  'createdAt': instance.createdAt?.toIso8601String(),
};

const _$ParcelSourceEnumMap = {
  ParcelSource.NOVA_POSHTA: 'NOVA_POSHTA',
  ParcelSource.MANUAL: 'MANUAL',
  ParcelSource.unknown: 'unknown',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.UNPAID: 'UNPAID',
  PaymentStatus.PAID: 'PAID',
  PaymentStatus.unknown: 'unknown',
};

const _$ChannelEnumMap = {
  Channel.TELEGRAM: 'TELEGRAM',
  Channel.VIBER: 'VIBER',
  Channel.WHATSAPP: 'WHATSAPP',
  Channel.INSTAGRAM: 'INSTAGRAM',
  Channel.FACEBOOK: 'FACEBOOK',
  Channel.TIKTOK: 'TIKTOK',
  Channel.WEBSITE: 'WEBSITE',
  Channel.PHONE_CALL: 'PHONE_CALL',
  Channel.REFERRAL: 'REFERRAL',
  Channel.OTHER: 'OTHER',
  Channel.unknown: 'unknown',
};

const _$NpStateEnumMap = {
  NpState.CREATED: 'CREATED',
  NpState.IN_TRANSIT: 'IN_TRANSIT',
  NpState.ARRIVED: 'ARRIVED',
  NpState.RECEIVED: 'RECEIVED',
  NpState.REDIRECTED: 'REDIRECTED',
  NpState.RETURNING: 'RETURNING',
  NpState.DELIVERY_FAILED: 'DELIVERY_FAILED',
  NpState.NOT_FOUND: 'NOT_FOUND',
  NpState.OTHER: 'OTHER',
  NpState.unknown: 'unknown',
};
