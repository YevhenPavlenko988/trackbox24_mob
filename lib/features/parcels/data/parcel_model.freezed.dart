// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Seat {

 int get seatNumber; String? get barcode;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get status; DateTime? get statusChangedAt; String? get statusChangedBy; int? get warehouseId; String? get warehouseName;
/// Create a copy of Seat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeatCopyWith<Seat> get copyWith => _$SeatCopyWithImpl<Seat>(this as Seat, _$identity);

  /// Serializes this Seat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Seat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Seat&&(identical(other.seatNumber, _this.seatNumber) || other.seatNumber == _this.seatNumber)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusChangedAt, _this.statusChangedAt) || other.statusChangedAt == _this.statusChangedAt)&&(identical(other.statusChangedBy, _this.statusChangedBy) || other.statusChangedBy == _this.statusChangedBy)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Seat;
  return Object.hash(runtimeType,_this.seatNumber,_this.barcode,_this.status,_this.statusChangedAt,_this.statusChangedBy,_this.warehouseId,_this.warehouseName);
}

@override
String toString() {
  final _this = this as Seat;
  return 'Seat(seatNumber: ${_this.seatNumber}, barcode: ${_this.barcode}, status: ${_this.status}, statusChangedAt: ${_this.statusChangedAt}, statusChangedBy: ${_this.statusChangedBy}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName})';
}


}

/// @nodoc
abstract mixin class $SeatCopyWith<$Res>  {
  factory $SeatCopyWith(Seat value, $Res Function(Seat) _then) = _$SeatCopyWithImpl;
@useResult
$Res call({
 int seatNumber, String? barcode,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, int? warehouseId, String? warehouseName
});




}
/// @nodoc
class _$SeatCopyWithImpl<$Res>
    implements $SeatCopyWith<$Res> {
  _$SeatCopyWithImpl(this._self, this._then);

  final Seat _self;
  final $Res Function(Seat) _then;

/// Create a copy of Seat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seatNumber = null,Object? barcode = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,}) {
  return _then(Seat(
seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Seat].
extension SeatPatterns on Seat {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Seat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Seat value)  $default,){
final _that = this;
switch (_that) {
case _Seat():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Seat value)?  $default,){
final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName)  $default,) {final _that = this;
switch (_that) {
case _Seat():
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName)?  $default,) {final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Seat implements Seat {
  const _Seat({required this.seatNumber, this.barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.status, this.statusChangedAt, this.statusChangedBy, this.warehouseId, this.warehouseName});
  factory _Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

@override final  int seatNumber;
@override final  String? barcode;
@override@JsonKey(unknownEnumValue: ParcelStatus.unknown) final  ParcelStatus? status;
@override final  DateTime? statusChangedAt;
@override final  String? statusChangedBy;
@override final  int? warehouseId;
@override final  String? warehouseName;

/// Create a copy of Seat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeatCopyWith<_Seat> get copyWith => __$SeatCopyWithImpl<_Seat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SeatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Seat&&(identical(other.seatNumber, seatNumber) || other.seatNumber == seatNumber)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.statusChangedBy, statusChangedBy) || other.statusChangedBy == statusChangedBy)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seatNumber,barcode,status,statusChangedAt,statusChangedBy,warehouseId,warehouseName);
}

@override
String toString() {
    return 'Seat(seatNumber: $seatNumber, barcode: $barcode, status: $status, statusChangedAt: $statusChangedAt, statusChangedBy: $statusChangedBy, warehouseId: $warehouseId, warehouseName: $warehouseName)';
}


}

/// @nodoc
abstract mixin class _$SeatCopyWith<$Res> implements $SeatCopyWith<$Res> {
  factory _$SeatCopyWith(_Seat value, $Res Function(_Seat) _then) = __$SeatCopyWithImpl;
@override @useResult
$Res call({
 int seatNumber, String? barcode,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, int? warehouseId, String? warehouseName
});




}
/// @nodoc
class __$SeatCopyWithImpl<$Res>
    implements _$SeatCopyWith<$Res> {
  __$SeatCopyWithImpl(this._self, this._then);

  final _Seat _self;
  final $Res Function(_Seat) _then;

/// Create a copy of Seat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seatNumber = null,Object? barcode = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,}) {
  return _then(_Seat(
seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Parcel {

 int get id; String? get barcode;@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? get source;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get status; DateTime? get statusChangedAt; String? get statusChangedBy; bool get needsEnrichment; int? get representativeId; String? get representativeName; int? get clientId; String? get clientName; String? get clientPhone; String? get clientCity; String? get clientAddress; String? get description; double? get weightKg; int? get seatsAmount; double? get lengthCm; double? get widthCm; double? get heightCm; String? get deliveryCity; double? get declaredValue; double? get deliveryPrice; String? get deliveryPriceCurrency;@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? get paymentStatus; DateTime? get paidAt; String? get paidBy; String? get senderName; String? get senderPhone; String? get senderCity; String? get notes; String? get npTtn; String? get npPreviousTtn; String? get npStatusCode;@JsonKey(unknownEnumValue: NpState.unknown) NpState? get npState; String? get npStatusText; DateTime? get npStatusUpdatedAt; String? get npRecipientWarehouse; DateTime? get npScheduledDeliveryAt; DateTime? get npArrivedAt; DateTime? get npPaidStorageFrom; double? get npDeliveryCost; double? get npCodAmount; String? get npPayerType; String? get npPaymentMethod; double? get npPreviousDeliveryCost; double? get npAmountToPay; double? get npVolumeWeight; List<Seat> get seats; int? get warehouseId; String? get warehouseName; int? get plannedTripId; int? get tripId; DateTime? get createdAt;
/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelCopyWith<Parcel> get copyWith => _$ParcelCopyWithImpl<Parcel>(this as Parcel, _$identity);

  /// Serializes this Parcel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Parcel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Parcel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusChangedAt, _this.statusChangedAt) || other.statusChangedAt == _this.statusChangedAt)&&(identical(other.statusChangedBy, _this.statusChangedBy) || other.statusChangedBy == _this.statusChangedBy)&&(identical(other.needsEnrichment, _this.needsEnrichment) || other.needsEnrichment == _this.needsEnrichment)&&(identical(other.representativeId, _this.representativeId) || other.representativeId == _this.representativeId)&&(identical(other.representativeName, _this.representativeName) || other.representativeName == _this.representativeName)&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.clientName, _this.clientName) || other.clientName == _this.clientName)&&(identical(other.clientPhone, _this.clientPhone) || other.clientPhone == _this.clientPhone)&&(identical(other.clientCity, _this.clientCity) || other.clientCity == _this.clientCity)&&(identical(other.clientAddress, _this.clientAddress) || other.clientAddress == _this.clientAddress)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.seatsAmount, _this.seatsAmount) || other.seatsAmount == _this.seatsAmount)&&(identical(other.lengthCm, _this.lengthCm) || other.lengthCm == _this.lengthCm)&&(identical(other.widthCm, _this.widthCm) || other.widthCm == _this.widthCm)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.deliveryCity, _this.deliveryCity) || other.deliveryCity == _this.deliveryCity)&&(identical(other.declaredValue, _this.declaredValue) || other.declaredValue == _this.declaredValue)&&(identical(other.deliveryPrice, _this.deliveryPrice) || other.deliveryPrice == _this.deliveryPrice)&&(identical(other.deliveryPriceCurrency, _this.deliveryPriceCurrency) || other.deliveryPriceCurrency == _this.deliveryPriceCurrency)&&(identical(other.paymentStatus, _this.paymentStatus) || other.paymentStatus == _this.paymentStatus)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.paidBy, _this.paidBy) || other.paidBy == _this.paidBy)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.senderPhone, _this.senderPhone) || other.senderPhone == _this.senderPhone)&&(identical(other.senderCity, _this.senderCity) || other.senderCity == _this.senderCity)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.npTtn, _this.npTtn) || other.npTtn == _this.npTtn)&&(identical(other.npPreviousTtn, _this.npPreviousTtn) || other.npPreviousTtn == _this.npPreviousTtn)&&(identical(other.npStatusCode, _this.npStatusCode) || other.npStatusCode == _this.npStatusCode)&&(identical(other.npState, _this.npState) || other.npState == _this.npState)&&(identical(other.npStatusText, _this.npStatusText) || other.npStatusText == _this.npStatusText)&&(identical(other.npStatusUpdatedAt, _this.npStatusUpdatedAt) || other.npStatusUpdatedAt == _this.npStatusUpdatedAt)&&(identical(other.npRecipientWarehouse, _this.npRecipientWarehouse) || other.npRecipientWarehouse == _this.npRecipientWarehouse)&&(identical(other.npScheduledDeliveryAt, _this.npScheduledDeliveryAt) || other.npScheduledDeliveryAt == _this.npScheduledDeliveryAt)&&(identical(other.npArrivedAt, _this.npArrivedAt) || other.npArrivedAt == _this.npArrivedAt)&&(identical(other.npPaidStorageFrom, _this.npPaidStorageFrom) || other.npPaidStorageFrom == _this.npPaidStorageFrom)&&(identical(other.npDeliveryCost, _this.npDeliveryCost) || other.npDeliveryCost == _this.npDeliveryCost)&&(identical(other.npCodAmount, _this.npCodAmount) || other.npCodAmount == _this.npCodAmount)&&(identical(other.npPayerType, _this.npPayerType) || other.npPayerType == _this.npPayerType)&&(identical(other.npPaymentMethod, _this.npPaymentMethod) || other.npPaymentMethod == _this.npPaymentMethod)&&(identical(other.npPreviousDeliveryCost, _this.npPreviousDeliveryCost) || other.npPreviousDeliveryCost == _this.npPreviousDeliveryCost)&&(identical(other.npAmountToPay, _this.npAmountToPay) || other.npAmountToPay == _this.npAmountToPay)&&(identical(other.npVolumeWeight, _this.npVolumeWeight) || other.npVolumeWeight == _this.npVolumeWeight)&&const DeepCollectionEquality().equals(other.seats, _this.seats)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.plannedTripId, _this.plannedTripId) || other.plannedTripId == _this.plannedTripId)&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Parcel;
  return Object.hashAll([runtimeType,_this.id,_this.barcode,_this.source,_this.status,_this.statusChangedAt,_this.statusChangedBy,_this.needsEnrichment,_this.representativeId,_this.representativeName,_this.clientId,_this.clientName,_this.clientPhone,_this.clientCity,_this.clientAddress,_this.description,_this.weightKg,_this.seatsAmount,_this.lengthCm,_this.widthCm,_this.heightCm,_this.deliveryCity,_this.declaredValue,_this.deliveryPrice,_this.deliveryPriceCurrency,_this.paymentStatus,_this.paidAt,_this.paidBy,_this.senderName,_this.senderPhone,_this.senderCity,_this.notes,_this.npTtn,_this.npPreviousTtn,_this.npStatusCode,_this.npState,_this.npStatusText,_this.npStatusUpdatedAt,_this.npRecipientWarehouse,_this.npScheduledDeliveryAt,_this.npArrivedAt,_this.npPaidStorageFrom,_this.npDeliveryCost,_this.npCodAmount,_this.npPayerType,_this.npPaymentMethod,_this.npPreviousDeliveryCost,_this.npAmountToPay,_this.npVolumeWeight,const DeepCollectionEquality().hash(_this.seats),_this.warehouseId,_this.warehouseName,_this.plannedTripId,_this.tripId,_this.createdAt]);
}

@override
String toString() {
  final _this = this as Parcel;
  return 'Parcel(id: ${_this.id}, barcode: ${_this.barcode}, source: ${_this.source}, status: ${_this.status}, statusChangedAt: ${_this.statusChangedAt}, statusChangedBy: ${_this.statusChangedBy}, needsEnrichment: ${_this.needsEnrichment}, representativeId: ${_this.representativeId}, representativeName: ${_this.representativeName}, clientId: ${_this.clientId}, clientName: ${_this.clientName}, clientPhone: ${_this.clientPhone}, clientCity: ${_this.clientCity}, clientAddress: ${_this.clientAddress}, description: ${_this.description}, weightKg: ${_this.weightKg}, seatsAmount: ${_this.seatsAmount}, lengthCm: ${_this.lengthCm}, widthCm: ${_this.widthCm}, heightCm: ${_this.heightCm}, deliveryCity: ${_this.deliveryCity}, declaredValue: ${_this.declaredValue}, deliveryPrice: ${_this.deliveryPrice}, deliveryPriceCurrency: ${_this.deliveryPriceCurrency}, paymentStatus: ${_this.paymentStatus}, paidAt: ${_this.paidAt}, paidBy: ${_this.paidBy}, senderName: ${_this.senderName}, senderPhone: ${_this.senderPhone}, senderCity: ${_this.senderCity}, notes: ${_this.notes}, npTtn: ${_this.npTtn}, npPreviousTtn: ${_this.npPreviousTtn}, npStatusCode: ${_this.npStatusCode}, npState: ${_this.npState}, npStatusText: ${_this.npStatusText}, npStatusUpdatedAt: ${_this.npStatusUpdatedAt}, npRecipientWarehouse: ${_this.npRecipientWarehouse}, npScheduledDeliveryAt: ${_this.npScheduledDeliveryAt}, npArrivedAt: ${_this.npArrivedAt}, npPaidStorageFrom: ${_this.npPaidStorageFrom}, npDeliveryCost: ${_this.npDeliveryCost}, npCodAmount: ${_this.npCodAmount}, npPayerType: ${_this.npPayerType}, npPaymentMethod: ${_this.npPaymentMethod}, npPreviousDeliveryCost: ${_this.npPreviousDeliveryCost}, npAmountToPay: ${_this.npAmountToPay}, npVolumeWeight: ${_this.npVolumeWeight}, seats: ${_this.seats}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName}, plannedTripId: ${_this.plannedTripId}, tripId: ${_this.tripId}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ParcelCopyWith<$Res>  {
  factory $ParcelCopyWith(Parcel value, $Res Function(Parcel) _then) = _$ParcelCopyWithImpl;
@useResult
$Res call({
 int id, String? barcode,@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? source,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, bool needsEnrichment, int? representativeId, String? representativeName, int? clientId, String? clientName, String? clientPhone, String? clientCity, String? clientAddress, String? description, double? weightKg, int? seatsAmount, double? lengthCm, double? widthCm, double? heightCm, String? deliveryCity, double? declaredValue, double? deliveryPrice, String? deliveryPriceCurrency,@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? paymentStatus, DateTime? paidAt, String? paidBy, String? senderName, String? senderPhone, String? senderCity, String? notes, String? npTtn, String? npPreviousTtn, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt, String? npRecipientWarehouse, DateTime? npScheduledDeliveryAt, DateTime? npArrivedAt, DateTime? npPaidStorageFrom, double? npDeliveryCost, double? npCodAmount, String? npPayerType, String? npPaymentMethod, double? npPreviousDeliveryCost, double? npAmountToPay, double? npVolumeWeight, List<Seat> seats, int? warehouseId, String? warehouseName, int? plannedTripId, int? tripId, DateTime? createdAt
});




}
/// @nodoc
class _$ParcelCopyWithImpl<$Res>
    implements $ParcelCopyWith<$Res> {
  _$ParcelCopyWithImpl(this._self, this._then);

  final Parcel _self;
  final $Res Function(Parcel) _then;

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? barcode = freezed,Object? source = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? needsEnrichment = null,Object? representativeId = freezed,Object? representativeName = freezed,Object? clientId = freezed,Object? clientName = freezed,Object? clientPhone = freezed,Object? clientCity = freezed,Object? clientAddress = freezed,Object? description = freezed,Object? weightKg = freezed,Object? seatsAmount = freezed,Object? lengthCm = freezed,Object? widthCm = freezed,Object? heightCm = freezed,Object? deliveryCity = freezed,Object? declaredValue = freezed,Object? deliveryPrice = freezed,Object? deliveryPriceCurrency = freezed,Object? paymentStatus = freezed,Object? paidAt = freezed,Object? paidBy = freezed,Object? senderName = freezed,Object? senderPhone = freezed,Object? senderCity = freezed,Object? notes = freezed,Object? npTtn = freezed,Object? npPreviousTtn = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,Object? npRecipientWarehouse = freezed,Object? npScheduledDeliveryAt = freezed,Object? npArrivedAt = freezed,Object? npPaidStorageFrom = freezed,Object? npDeliveryCost = freezed,Object? npCodAmount = freezed,Object? npPayerType = freezed,Object? npPaymentMethod = freezed,Object? npPreviousDeliveryCost = freezed,Object? npAmountToPay = freezed,Object? npVolumeWeight = freezed,Object? seats = null,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? plannedTripId = freezed,Object? tripId = freezed,Object? createdAt = freezed,}) {
  return _then(Parcel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ParcelSource?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,needsEnrichment: null == needsEnrichment ? _self.needsEnrichment : needsEnrichment // ignore: cast_nullable_to_non_nullable
as bool,representativeId: freezed == representativeId ? _self.representativeId : representativeId // ignore: cast_nullable_to_non_nullable
as int?,representativeName: freezed == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientPhone: freezed == clientPhone ? _self.clientPhone : clientPhone // ignore: cast_nullable_to_non_nullable
as String?,clientCity: freezed == clientCity ? _self.clientCity : clientCity // ignore: cast_nullable_to_non_nullable
as String?,clientAddress: freezed == clientAddress ? _self.clientAddress : clientAddress // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,seatsAmount: freezed == seatsAmount ? _self.seatsAmount : seatsAmount // ignore: cast_nullable_to_non_nullable
as int?,lengthCm: freezed == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as double?,widthCm: freezed == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,deliveryCity: freezed == deliveryCity ? _self.deliveryCity : deliveryCity // ignore: cast_nullable_to_non_nullable
as String?,declaredValue: freezed == declaredValue ? _self.declaredValue : declaredValue // ignore: cast_nullable_to_non_nullable
as double?,deliveryPrice: freezed == deliveryPrice ? _self.deliveryPrice : deliveryPrice // ignore: cast_nullable_to_non_nullable
as double?,deliveryPriceCurrency: freezed == deliveryPriceCurrency ? _self.deliveryPriceCurrency : deliveryPriceCurrency // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderPhone: freezed == senderPhone ? _self.senderPhone : senderPhone // ignore: cast_nullable_to_non_nullable
as String?,senderCity: freezed == senderCity ? _self.senderCity : senderCity // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,npTtn: freezed == npTtn ? _self.npTtn : npTtn // ignore: cast_nullable_to_non_nullable
as String?,npPreviousTtn: freezed == npPreviousTtn ? _self.npPreviousTtn : npPreviousTtn // ignore: cast_nullable_to_non_nullable
as String?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npState: freezed == npState ? _self.npState : npState // ignore: cast_nullable_to_non_nullable
as NpState?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,npStatusUpdatedAt: freezed == npStatusUpdatedAt ? _self.npStatusUpdatedAt : npStatusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npRecipientWarehouse: freezed == npRecipientWarehouse ? _self.npRecipientWarehouse : npRecipientWarehouse // ignore: cast_nullable_to_non_nullable
as String?,npScheduledDeliveryAt: freezed == npScheduledDeliveryAt ? _self.npScheduledDeliveryAt : npScheduledDeliveryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npArrivedAt: freezed == npArrivedAt ? _self.npArrivedAt : npArrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npPaidStorageFrom: freezed == npPaidStorageFrom ? _self.npPaidStorageFrom : npPaidStorageFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,npDeliveryCost: freezed == npDeliveryCost ? _self.npDeliveryCost : npDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npCodAmount: freezed == npCodAmount ? _self.npCodAmount : npCodAmount // ignore: cast_nullable_to_non_nullable
as double?,npPayerType: freezed == npPayerType ? _self.npPayerType : npPayerType // ignore: cast_nullable_to_non_nullable
as String?,npPaymentMethod: freezed == npPaymentMethod ? _self.npPaymentMethod : npPaymentMethod // ignore: cast_nullable_to_non_nullable
as String?,npPreviousDeliveryCost: freezed == npPreviousDeliveryCost ? _self.npPreviousDeliveryCost : npPreviousDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npAmountToPay: freezed == npAmountToPay ? _self.npAmountToPay : npAmountToPay // ignore: cast_nullable_to_non_nullable
as double?,npVolumeWeight: freezed == npVolumeWeight ? _self.npVolumeWeight : npVolumeWeight // ignore: cast_nullable_to_non_nullable
as double?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as List<Seat>,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,plannedTripId: freezed == plannedTripId ? _self.plannedTripId : plannedTripId // ignore: cast_nullable_to_non_nullable
as int?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Parcel].
extension ParcelPatterns on Parcel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Parcel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Parcel value)  $default,){
final _that = this;
switch (_that) {
case _Parcel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Parcel value)?  $default,){
final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npVolumeWeight,  List<Seat> seats,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npVolumeWeight,_that.seats,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npVolumeWeight,  List<Seat> seats,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _Parcel():
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npVolumeWeight,_that.seats,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npVolumeWeight,  List<Seat> seats,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npVolumeWeight,_that.seats,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Parcel extends Parcel {
  const _Parcel({required this.id, this.barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown) this.source, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.status, this.statusChangedAt, this.statusChangedBy, this.needsEnrichment = false, this.representativeId, this.representativeName, this.clientId, this.clientName, this.clientPhone, this.clientCity, this.clientAddress, this.description, this.weightKg, this.seatsAmount, this.lengthCm, this.widthCm, this.heightCm, this.deliveryCity, this.declaredValue, this.deliveryPrice, this.deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown) this.paymentStatus, this.paidAt, this.paidBy, this.senderName, this.senderPhone, this.senderCity, this.notes, this.npTtn, this.npPreviousTtn, this.npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown) this.npState, this.npStatusText, this.npStatusUpdatedAt, this.npRecipientWarehouse, this.npScheduledDeliveryAt, this.npArrivedAt, this.npPaidStorageFrom, this.npDeliveryCost, this.npCodAmount, this.npPayerType, this.npPaymentMethod, this.npPreviousDeliveryCost, this.npAmountToPay, this.npVolumeWeight,  List<Seat> seats = const [], this.warehouseId, this.warehouseName, this.plannedTripId, this.tripId, this.createdAt}): _seats = seats,super._();
  factory _Parcel.fromJson(Map<String, dynamic> json) => _$ParcelFromJson(json);

@override final  int id;
@override final  String? barcode;
@override@JsonKey(unknownEnumValue: ParcelSource.unknown) final  ParcelSource? source;
@override@JsonKey(unknownEnumValue: ParcelStatus.unknown) final  ParcelStatus? status;
@override final  DateTime? statusChangedAt;
@override final  String? statusChangedBy;
@override@JsonKey() final  bool needsEnrichment;
@override final  int? representativeId;
@override final  String? representativeName;
@override final  int? clientId;
@override final  String? clientName;
@override final  String? clientPhone;
@override final  String? clientCity;
@override final  String? clientAddress;
@override final  String? description;
@override final  double? weightKg;
@override final  int? seatsAmount;
@override final  double? lengthCm;
@override final  double? widthCm;
@override final  double? heightCm;
@override final  String? deliveryCity;
@override final  double? declaredValue;
@override final  double? deliveryPrice;
@override final  String? deliveryPriceCurrency;
@override@JsonKey(unknownEnumValue: PaymentStatus.unknown) final  PaymentStatus? paymentStatus;
@override final  DateTime? paidAt;
@override final  String? paidBy;
@override final  String? senderName;
@override final  String? senderPhone;
@override final  String? senderCity;
@override final  String? notes;
@override final  String? npTtn;
@override final  String? npPreviousTtn;
@override final  String? npStatusCode;
@override@JsonKey(unknownEnumValue: NpState.unknown) final  NpState? npState;
@override final  String? npStatusText;
@override final  DateTime? npStatusUpdatedAt;
@override final  String? npRecipientWarehouse;
@override final  DateTime? npScheduledDeliveryAt;
@override final  DateTime? npArrivedAt;
@override final  DateTime? npPaidStorageFrom;
@override final  double? npDeliveryCost;
@override final  double? npCodAmount;
@override final  String? npPayerType;
@override final  String? npPaymentMethod;
@override final  double? npPreviousDeliveryCost;
@override final  double? npAmountToPay;
@override final  double? npVolumeWeight;
 final  List<Seat> _seats;
@override@JsonKey() List<Seat> get seats {
  if (_seats is EqualUnmodifiableListView) return _seats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seats);
}

@override final  int? warehouseId;
@override final  String? warehouseName;
@override final  int? plannedTripId;
@override final  int? tripId;
@override final  DateTime? createdAt;

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelCopyWith<_Parcel> get copyWith => __$ParcelCopyWithImpl<_Parcel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParcelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Parcel&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.statusChangedBy, statusChangedBy) || other.statusChangedBy == statusChangedBy)&&(identical(other.needsEnrichment, needsEnrichment) || other.needsEnrichment == needsEnrichment)&&(identical(other.representativeId, representativeId) || other.representativeId == representativeId)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientPhone, clientPhone) || other.clientPhone == clientPhone)&&(identical(other.clientCity, clientCity) || other.clientCity == clientCity)&&(identical(other.clientAddress, clientAddress) || other.clientAddress == clientAddress)&&(identical(other.description, description) || other.description == description)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.seatsAmount, seatsAmount) || other.seatsAmount == seatsAmount)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.deliveryCity, deliveryCity) || other.deliveryCity == deliveryCity)&&(identical(other.declaredValue, declaredValue) || other.declaredValue == declaredValue)&&(identical(other.deliveryPrice, deliveryPrice) || other.deliveryPrice == deliveryPrice)&&(identical(other.deliveryPriceCurrency, deliveryPriceCurrency) || other.deliveryPriceCurrency == deliveryPriceCurrency)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderPhone, senderPhone) || other.senderPhone == senderPhone)&&(identical(other.senderCity, senderCity) || other.senderCity == senderCity)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.npTtn, npTtn) || other.npTtn == npTtn)&&(identical(other.npPreviousTtn, npPreviousTtn) || other.npPreviousTtn == npPreviousTtn)&&(identical(other.npStatusCode, npStatusCode) || other.npStatusCode == npStatusCode)&&(identical(other.npState, npState) || other.npState == npState)&&(identical(other.npStatusText, npStatusText) || other.npStatusText == npStatusText)&&(identical(other.npStatusUpdatedAt, npStatusUpdatedAt) || other.npStatusUpdatedAt == npStatusUpdatedAt)&&(identical(other.npRecipientWarehouse, npRecipientWarehouse) || other.npRecipientWarehouse == npRecipientWarehouse)&&(identical(other.npScheduledDeliveryAt, npScheduledDeliveryAt) || other.npScheduledDeliveryAt == npScheduledDeliveryAt)&&(identical(other.npArrivedAt, npArrivedAt) || other.npArrivedAt == npArrivedAt)&&(identical(other.npPaidStorageFrom, npPaidStorageFrom) || other.npPaidStorageFrom == npPaidStorageFrom)&&(identical(other.npDeliveryCost, npDeliveryCost) || other.npDeliveryCost == npDeliveryCost)&&(identical(other.npCodAmount, npCodAmount) || other.npCodAmount == npCodAmount)&&(identical(other.npPayerType, npPayerType) || other.npPayerType == npPayerType)&&(identical(other.npPaymentMethod, npPaymentMethod) || other.npPaymentMethod == npPaymentMethod)&&(identical(other.npPreviousDeliveryCost, npPreviousDeliveryCost) || other.npPreviousDeliveryCost == npPreviousDeliveryCost)&&(identical(other.npAmountToPay, npAmountToPay) || other.npAmountToPay == npAmountToPay)&&(identical(other.npVolumeWeight, npVolumeWeight) || other.npVolumeWeight == npVolumeWeight)&&const DeepCollectionEquality().equals(other.seats, _seats)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.plannedTripId, plannedTripId) || other.plannedTripId == plannedTripId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,barcode,source,status,statusChangedAt,statusChangedBy,needsEnrichment,representativeId,representativeName,clientId,clientName,clientPhone,clientCity,clientAddress,description,weightKg,seatsAmount,lengthCm,widthCm,heightCm,deliveryCity,declaredValue,deliveryPrice,deliveryPriceCurrency,paymentStatus,paidAt,paidBy,senderName,senderPhone,senderCity,notes,npTtn,npPreviousTtn,npStatusCode,npState,npStatusText,npStatusUpdatedAt,npRecipientWarehouse,npScheduledDeliveryAt,npArrivedAt,npPaidStorageFrom,npDeliveryCost,npCodAmount,npPayerType,npPaymentMethod,npPreviousDeliveryCost,npAmountToPay,npVolumeWeight,const DeepCollectionEquality().hash(_seats),warehouseId,warehouseName,plannedTripId,tripId,createdAt]);
}

@override
String toString() {
    return 'Parcel(id: $id, barcode: $barcode, source: $source, status: $status, statusChangedAt: $statusChangedAt, statusChangedBy: $statusChangedBy, needsEnrichment: $needsEnrichment, representativeId: $representativeId, representativeName: $representativeName, clientId: $clientId, clientName: $clientName, clientPhone: $clientPhone, clientCity: $clientCity, clientAddress: $clientAddress, description: $description, weightKg: $weightKg, seatsAmount: $seatsAmount, lengthCm: $lengthCm, widthCm: $widthCm, heightCm: $heightCm, deliveryCity: $deliveryCity, declaredValue: $declaredValue, deliveryPrice: $deliveryPrice, deliveryPriceCurrency: $deliveryPriceCurrency, paymentStatus: $paymentStatus, paidAt: $paidAt, paidBy: $paidBy, senderName: $senderName, senderPhone: $senderPhone, senderCity: $senderCity, notes: $notes, npTtn: $npTtn, npPreviousTtn: $npPreviousTtn, npStatusCode: $npStatusCode, npState: $npState, npStatusText: $npStatusText, npStatusUpdatedAt: $npStatusUpdatedAt, npRecipientWarehouse: $npRecipientWarehouse, npScheduledDeliveryAt: $npScheduledDeliveryAt, npArrivedAt: $npArrivedAt, npPaidStorageFrom: $npPaidStorageFrom, npDeliveryCost: $npDeliveryCost, npCodAmount: $npCodAmount, npPayerType: $npPayerType, npPaymentMethod: $npPaymentMethod, npPreviousDeliveryCost: $npPreviousDeliveryCost, npAmountToPay: $npAmountToPay, npVolumeWeight: $npVolumeWeight, seats: $seats, warehouseId: $warehouseId, warehouseName: $warehouseName, plannedTripId: $plannedTripId, tripId: $tripId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ParcelCopyWith<$Res> implements $ParcelCopyWith<$Res> {
  factory _$ParcelCopyWith(_Parcel value, $Res Function(_Parcel) _then) = __$ParcelCopyWithImpl;
@override @useResult
$Res call({
 int id, String? barcode,@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? source,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, bool needsEnrichment, int? representativeId, String? representativeName, int? clientId, String? clientName, String? clientPhone, String? clientCity, String? clientAddress, String? description, double? weightKg, int? seatsAmount, double? lengthCm, double? widthCm, double? heightCm, String? deliveryCity, double? declaredValue, double? deliveryPrice, String? deliveryPriceCurrency,@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? paymentStatus, DateTime? paidAt, String? paidBy, String? senderName, String? senderPhone, String? senderCity, String? notes, String? npTtn, String? npPreviousTtn, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt, String? npRecipientWarehouse, DateTime? npScheduledDeliveryAt, DateTime? npArrivedAt, DateTime? npPaidStorageFrom, double? npDeliveryCost, double? npCodAmount, String? npPayerType, String? npPaymentMethod, double? npPreviousDeliveryCost, double? npAmountToPay, double? npVolumeWeight, List<Seat> seats, int? warehouseId, String? warehouseName, int? plannedTripId, int? tripId, DateTime? createdAt
});




}
/// @nodoc
class __$ParcelCopyWithImpl<$Res>
    implements _$ParcelCopyWith<$Res> {
  __$ParcelCopyWithImpl(this._self, this._then);

  final _Parcel _self;
  final $Res Function(_Parcel) _then;

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? barcode = freezed,Object? source = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? needsEnrichment = null,Object? representativeId = freezed,Object? representativeName = freezed,Object? clientId = freezed,Object? clientName = freezed,Object? clientPhone = freezed,Object? clientCity = freezed,Object? clientAddress = freezed,Object? description = freezed,Object? weightKg = freezed,Object? seatsAmount = freezed,Object? lengthCm = freezed,Object? widthCm = freezed,Object? heightCm = freezed,Object? deliveryCity = freezed,Object? declaredValue = freezed,Object? deliveryPrice = freezed,Object? deliveryPriceCurrency = freezed,Object? paymentStatus = freezed,Object? paidAt = freezed,Object? paidBy = freezed,Object? senderName = freezed,Object? senderPhone = freezed,Object? senderCity = freezed,Object? notes = freezed,Object? npTtn = freezed,Object? npPreviousTtn = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,Object? npRecipientWarehouse = freezed,Object? npScheduledDeliveryAt = freezed,Object? npArrivedAt = freezed,Object? npPaidStorageFrom = freezed,Object? npDeliveryCost = freezed,Object? npCodAmount = freezed,Object? npPayerType = freezed,Object? npPaymentMethod = freezed,Object? npPreviousDeliveryCost = freezed,Object? npAmountToPay = freezed,Object? npVolumeWeight = freezed,Object? seats = null,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? plannedTripId = freezed,Object? tripId = freezed,Object? createdAt = freezed,}) {
  return _then(_Parcel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as ParcelSource?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,needsEnrichment: null == needsEnrichment ? _self.needsEnrichment : needsEnrichment // ignore: cast_nullable_to_non_nullable
as bool,representativeId: freezed == representativeId ? _self.representativeId : representativeId // ignore: cast_nullable_to_non_nullable
as int?,representativeName: freezed == representativeName ? _self.representativeName : representativeName // ignore: cast_nullable_to_non_nullable
as String?,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as int?,clientName: freezed == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String?,clientPhone: freezed == clientPhone ? _self.clientPhone : clientPhone // ignore: cast_nullable_to_non_nullable
as String?,clientCity: freezed == clientCity ? _self.clientCity : clientCity // ignore: cast_nullable_to_non_nullable
as String?,clientAddress: freezed == clientAddress ? _self.clientAddress : clientAddress // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,weightKg: freezed == weightKg ? _self.weightKg : weightKg // ignore: cast_nullable_to_non_nullable
as double?,seatsAmount: freezed == seatsAmount ? _self.seatsAmount : seatsAmount // ignore: cast_nullable_to_non_nullable
as int?,lengthCm: freezed == lengthCm ? _self.lengthCm : lengthCm // ignore: cast_nullable_to_non_nullable
as double?,widthCm: freezed == widthCm ? _self.widthCm : widthCm // ignore: cast_nullable_to_non_nullable
as double?,heightCm: freezed == heightCm ? _self.heightCm : heightCm // ignore: cast_nullable_to_non_nullable
as double?,deliveryCity: freezed == deliveryCity ? _self.deliveryCity : deliveryCity // ignore: cast_nullable_to_non_nullable
as String?,declaredValue: freezed == declaredValue ? _self.declaredValue : declaredValue // ignore: cast_nullable_to_non_nullable
as double?,deliveryPrice: freezed == deliveryPrice ? _self.deliveryPrice : deliveryPrice // ignore: cast_nullable_to_non_nullable
as double?,deliveryPriceCurrency: freezed == deliveryPriceCurrency ? _self.deliveryPriceCurrency : deliveryPriceCurrency // ignore: cast_nullable_to_non_nullable
as String?,paymentStatus: freezed == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as PaymentStatus?,paidAt: freezed == paidAt ? _self.paidAt : paidAt // ignore: cast_nullable_to_non_nullable
as DateTime?,paidBy: freezed == paidBy ? _self.paidBy : paidBy // ignore: cast_nullable_to_non_nullable
as String?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderPhone: freezed == senderPhone ? _self.senderPhone : senderPhone // ignore: cast_nullable_to_non_nullable
as String?,senderCity: freezed == senderCity ? _self.senderCity : senderCity // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,npTtn: freezed == npTtn ? _self.npTtn : npTtn // ignore: cast_nullable_to_non_nullable
as String?,npPreviousTtn: freezed == npPreviousTtn ? _self.npPreviousTtn : npPreviousTtn // ignore: cast_nullable_to_non_nullable
as String?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npState: freezed == npState ? _self.npState : npState // ignore: cast_nullable_to_non_nullable
as NpState?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,npStatusUpdatedAt: freezed == npStatusUpdatedAt ? _self.npStatusUpdatedAt : npStatusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npRecipientWarehouse: freezed == npRecipientWarehouse ? _self.npRecipientWarehouse : npRecipientWarehouse // ignore: cast_nullable_to_non_nullable
as String?,npScheduledDeliveryAt: freezed == npScheduledDeliveryAt ? _self.npScheduledDeliveryAt : npScheduledDeliveryAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npArrivedAt: freezed == npArrivedAt ? _self.npArrivedAt : npArrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,npPaidStorageFrom: freezed == npPaidStorageFrom ? _self.npPaidStorageFrom : npPaidStorageFrom // ignore: cast_nullable_to_non_nullable
as DateTime?,npDeliveryCost: freezed == npDeliveryCost ? _self.npDeliveryCost : npDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npCodAmount: freezed == npCodAmount ? _self.npCodAmount : npCodAmount // ignore: cast_nullable_to_non_nullable
as double?,npPayerType: freezed == npPayerType ? _self.npPayerType : npPayerType // ignore: cast_nullable_to_non_nullable
as String?,npPaymentMethod: freezed == npPaymentMethod ? _self.npPaymentMethod : npPaymentMethod // ignore: cast_nullable_to_non_nullable
as String?,npPreviousDeliveryCost: freezed == npPreviousDeliveryCost ? _self.npPreviousDeliveryCost : npPreviousDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npAmountToPay: freezed == npAmountToPay ? _self.npAmountToPay : npAmountToPay // ignore: cast_nullable_to_non_nullable
as double?,npVolumeWeight: freezed == npVolumeWeight ? _self.npVolumeWeight : npVolumeWeight // ignore: cast_nullable_to_non_nullable
as double?,seats: null == seats ? _self._seats : seats // ignore: cast_nullable_to_non_nullable
as List<Seat>,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,plannedTripId: freezed == plannedTripId ? _self.plannedTripId : plannedTripId // ignore: cast_nullable_to_non_nullable
as int?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
