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

 int get seatNumber; String? get barcode;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get status; DateTime? get statusChangedAt; String? get statusChangedBy; int? get warehouseId; String? get warehouseName;/// What the item is (moves): «Диван», «Коробка — посуд».
 String? get description;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Seat&&(identical(other.seatNumber, _this.seatNumber) || other.seatNumber == _this.seatNumber)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusChangedAt, _this.statusChangedAt) || other.statusChangedAt == _this.statusChangedAt)&&(identical(other.statusChangedBy, _this.statusChangedBy) || other.statusChangedBy == _this.statusChangedBy)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Seat;
  return Object.hash(runtimeType,_this.seatNumber,_this.barcode,_this.status,_this.statusChangedAt,_this.statusChangedBy,_this.warehouseId,_this.warehouseName,_this.description);
}

@override
String toString() {
  final _this = this as Seat;
  return 'Seat(seatNumber: ${_this.seatNumber}, barcode: ${_this.barcode}, status: ${_this.status}, statusChangedAt: ${_this.statusChangedAt}, statusChangedBy: ${_this.statusChangedBy}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $SeatCopyWith<$Res>  {
  factory $SeatCopyWith(Seat value, $Res Function(Seat) _then) = _$SeatCopyWithImpl;
@useResult
$Res call({
 int seatNumber, String? barcode,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, int? warehouseId, String? warehouseName, String? description
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
@pragma('vm:prefer-inline') @override $Res call({Object? seatNumber = null,Object? barcode = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? description = freezed,}) {
  return _then(Seat(
seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Seat():
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seatNumber,  String? barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  int? warehouseId,  String? warehouseName,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Seat() when $default != null:
return $default(_that.seatNumber,_that.barcode,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.warehouseId,_that.warehouseName,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Seat implements Seat {
  const _Seat({required this.seatNumber, this.barcode, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.status, this.statusChangedAt, this.statusChangedBy, this.warehouseId, this.warehouseName, this.description});
  factory _Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);

@override final  int seatNumber;
@override final  String? barcode;
@override@JsonKey(unknownEnumValue: ParcelStatus.unknown) final  ParcelStatus? status;
@override final  DateTime? statusChangedAt;
@override final  String? statusChangedBy;
@override final  int? warehouseId;
@override final  String? warehouseName;
/// What the item is (moves): «Диван», «Коробка — посуд».
@override final  String? description;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Seat&&(identical(other.seatNumber, seatNumber) || other.seatNumber == seatNumber)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.statusChangedBy, statusChangedBy) || other.statusChangedBy == statusChangedBy)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seatNumber,barcode,status,statusChangedAt,statusChangedBy,warehouseId,warehouseName,description);
}

@override
String toString() {
    return 'Seat(seatNumber: $seatNumber, barcode: $barcode, status: $status, statusChangedAt: $statusChangedAt, statusChangedBy: $statusChangedBy, warehouseId: $warehouseId, warehouseName: $warehouseName, description: $description)';
}


}

/// @nodoc
abstract mixin class _$SeatCopyWith<$Res> implements $SeatCopyWith<$Res> {
  factory _$SeatCopyWith(_Seat value, $Res Function(_Seat) _then) = __$SeatCopyWithImpl;
@override @useResult
$Res call({
 int seatNumber, String? barcode,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, int? warehouseId, String? warehouseName, String? description
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
@override @pragma('vm:prefer-inline') $Res call({Object? seatNumber = null,Object? barcode = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? description = freezed,}) {
  return _then(_Seat(
seatNumber: null == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,statusChangedAt: freezed == statusChangedAt ? _self.statusChangedAt : statusChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,statusChangedBy: freezed == statusChangedBy ? _self.statusChangedBy : statusChangedBy // ignore: cast_nullable_to_non_nullable
as String?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NpShipment {

 String? get recipientLastName; String? get recipientFirstName; String? get recipientMiddleName; String? get recipientPhone;@JsonKey(unknownEnumValue: NpDeliveryType.unknown) NpDeliveryType? get deliveryType; String? get cityRef; String? get cityName; String? get warehouseRef; String? get warehouseName; String? get streetRef; String? get streetName; String? get building; String? get flat;@JsonKey(unknownEnumValue: NpCargoType.unknown) NpCargoType? get cargoType;@JsonKey(unknownEnumValue: NpPayerType.unknown) NpPayerType? get payerType;@JsonKey(unknownEnumValue: NpPaymentMethod.unknown) NpPaymentMethod? get paymentMethod; double? get codAmount; String? get waybillNumber; DateTime? get waybillCreatedAt; double? get waybillCost;/// Dispatch date written into the waybill: the parcel's trip arrives, plus a day.
 DateTime? get shipDate; DateTime? get estimatedDeliveryDate; String? get npStatusCode;@JsonKey(unknownEnumValue: NpState.unknown) NpState? get npState; String? get npStatusText; DateTime? get npStatusUpdatedAt;
/// Create a copy of NpShipment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpShipmentCopyWith<NpShipment> get copyWith => _$NpShipmentCopyWithImpl<NpShipment>(this as NpShipment, _$identity);

  /// Serializes this NpShipment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpShipment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpShipment&&(identical(other.recipientLastName, _this.recipientLastName) || other.recipientLastName == _this.recipientLastName)&&(identical(other.recipientFirstName, _this.recipientFirstName) || other.recipientFirstName == _this.recipientFirstName)&&(identical(other.recipientMiddleName, _this.recipientMiddleName) || other.recipientMiddleName == _this.recipientMiddleName)&&(identical(other.recipientPhone, _this.recipientPhone) || other.recipientPhone == _this.recipientPhone)&&(identical(other.deliveryType, _this.deliveryType) || other.deliveryType == _this.deliveryType)&&(identical(other.cityRef, _this.cityRef) || other.cityRef == _this.cityRef)&&(identical(other.cityName, _this.cityName) || other.cityName == _this.cityName)&&(identical(other.warehouseRef, _this.warehouseRef) || other.warehouseRef == _this.warehouseRef)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.streetRef, _this.streetRef) || other.streetRef == _this.streetRef)&&(identical(other.streetName, _this.streetName) || other.streetName == _this.streetName)&&(identical(other.building, _this.building) || other.building == _this.building)&&(identical(other.flat, _this.flat) || other.flat == _this.flat)&&(identical(other.cargoType, _this.cargoType) || other.cargoType == _this.cargoType)&&(identical(other.payerType, _this.payerType) || other.payerType == _this.payerType)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.codAmount, _this.codAmount) || other.codAmount == _this.codAmount)&&(identical(other.waybillNumber, _this.waybillNumber) || other.waybillNumber == _this.waybillNumber)&&(identical(other.waybillCreatedAt, _this.waybillCreatedAt) || other.waybillCreatedAt == _this.waybillCreatedAt)&&(identical(other.waybillCost, _this.waybillCost) || other.waybillCost == _this.waybillCost)&&(identical(other.shipDate, _this.shipDate) || other.shipDate == _this.shipDate)&&(identical(other.estimatedDeliveryDate, _this.estimatedDeliveryDate) || other.estimatedDeliveryDate == _this.estimatedDeliveryDate)&&(identical(other.npStatusCode, _this.npStatusCode) || other.npStatusCode == _this.npStatusCode)&&(identical(other.npState, _this.npState) || other.npState == _this.npState)&&(identical(other.npStatusText, _this.npStatusText) || other.npStatusText == _this.npStatusText)&&(identical(other.npStatusUpdatedAt, _this.npStatusUpdatedAt) || other.npStatusUpdatedAt == _this.npStatusUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpShipment;
  return Object.hashAll([runtimeType,_this.recipientLastName,_this.recipientFirstName,_this.recipientMiddleName,_this.recipientPhone,_this.deliveryType,_this.cityRef,_this.cityName,_this.warehouseRef,_this.warehouseName,_this.streetRef,_this.streetName,_this.building,_this.flat,_this.cargoType,_this.payerType,_this.paymentMethod,_this.codAmount,_this.waybillNumber,_this.waybillCreatedAt,_this.waybillCost,_this.shipDate,_this.estimatedDeliveryDate,_this.npStatusCode,_this.npState,_this.npStatusText,_this.npStatusUpdatedAt]);
}

@override
String toString() {
  final _this = this as NpShipment;
  return 'NpShipment(recipientLastName: ${_this.recipientLastName}, recipientFirstName: ${_this.recipientFirstName}, recipientMiddleName: ${_this.recipientMiddleName}, recipientPhone: ${_this.recipientPhone}, deliveryType: ${_this.deliveryType}, cityRef: ${_this.cityRef}, cityName: ${_this.cityName}, warehouseRef: ${_this.warehouseRef}, warehouseName: ${_this.warehouseName}, streetRef: ${_this.streetRef}, streetName: ${_this.streetName}, building: ${_this.building}, flat: ${_this.flat}, cargoType: ${_this.cargoType}, payerType: ${_this.payerType}, paymentMethod: ${_this.paymentMethod}, codAmount: ${_this.codAmount}, waybillNumber: ${_this.waybillNumber}, waybillCreatedAt: ${_this.waybillCreatedAt}, waybillCost: ${_this.waybillCost}, shipDate: ${_this.shipDate}, estimatedDeliveryDate: ${_this.estimatedDeliveryDate}, npStatusCode: ${_this.npStatusCode}, npState: ${_this.npState}, npStatusText: ${_this.npStatusText}, npStatusUpdatedAt: ${_this.npStatusUpdatedAt})';
}


}

/// @nodoc
abstract mixin class $NpShipmentCopyWith<$Res>  {
  factory $NpShipmentCopyWith(NpShipment value, $Res Function(NpShipment) _then) = _$NpShipmentCopyWithImpl;
@useResult
$Res call({
 String? recipientLastName, String? recipientFirstName, String? recipientMiddleName, String? recipientPhone,@JsonKey(unknownEnumValue: NpDeliveryType.unknown) NpDeliveryType? deliveryType, String? cityRef, String? cityName, String? warehouseRef, String? warehouseName, String? streetRef, String? streetName, String? building, String? flat,@JsonKey(unknownEnumValue: NpCargoType.unknown) NpCargoType? cargoType,@JsonKey(unknownEnumValue: NpPayerType.unknown) NpPayerType? payerType,@JsonKey(unknownEnumValue: NpPaymentMethod.unknown) NpPaymentMethod? paymentMethod, double? codAmount, String? waybillNumber, DateTime? waybillCreatedAt, double? waybillCost, DateTime? shipDate, DateTime? estimatedDeliveryDate, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt
});




}
/// @nodoc
class _$NpShipmentCopyWithImpl<$Res>
    implements $NpShipmentCopyWith<$Res> {
  _$NpShipmentCopyWithImpl(this._self, this._then);

  final NpShipment _self;
  final $Res Function(NpShipment) _then;

/// Create a copy of NpShipment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recipientLastName = freezed,Object? recipientFirstName = freezed,Object? recipientMiddleName = freezed,Object? recipientPhone = freezed,Object? deliveryType = freezed,Object? cityRef = freezed,Object? cityName = freezed,Object? warehouseRef = freezed,Object? warehouseName = freezed,Object? streetRef = freezed,Object? streetName = freezed,Object? building = freezed,Object? flat = freezed,Object? cargoType = freezed,Object? payerType = freezed,Object? paymentMethod = freezed,Object? codAmount = freezed,Object? waybillNumber = freezed,Object? waybillCreatedAt = freezed,Object? waybillCost = freezed,Object? shipDate = freezed,Object? estimatedDeliveryDate = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,}) {
  return _then(NpShipment(
recipientLastName: freezed == recipientLastName ? _self.recipientLastName : recipientLastName // ignore: cast_nullable_to_non_nullable
as String?,recipientFirstName: freezed == recipientFirstName ? _self.recipientFirstName : recipientFirstName // ignore: cast_nullable_to_non_nullable
as String?,recipientMiddleName: freezed == recipientMiddleName ? _self.recipientMiddleName : recipientMiddleName // ignore: cast_nullable_to_non_nullable
as String?,recipientPhone: freezed == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String?,deliveryType: freezed == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as NpDeliveryType?,cityRef: freezed == cityRef ? _self.cityRef : cityRef // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,warehouseRef: freezed == warehouseRef ? _self.warehouseRef : warehouseRef // ignore: cast_nullable_to_non_nullable
as String?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,streetRef: freezed == streetRef ? _self.streetRef : streetRef // ignore: cast_nullable_to_non_nullable
as String?,streetName: freezed == streetName ? _self.streetName : streetName // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,flat: freezed == flat ? _self.flat : flat // ignore: cast_nullable_to_non_nullable
as String?,cargoType: freezed == cargoType ? _self.cargoType : cargoType // ignore: cast_nullable_to_non_nullable
as NpCargoType?,payerType: freezed == payerType ? _self.payerType : payerType // ignore: cast_nullable_to_non_nullable
as NpPayerType?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as NpPaymentMethod?,codAmount: freezed == codAmount ? _self.codAmount : codAmount // ignore: cast_nullable_to_non_nullable
as double?,waybillNumber: freezed == waybillNumber ? _self.waybillNumber : waybillNumber // ignore: cast_nullable_to_non_nullable
as String?,waybillCreatedAt: freezed == waybillCreatedAt ? _self.waybillCreatedAt : waybillCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waybillCost: freezed == waybillCost ? _self.waybillCost : waybillCost // ignore: cast_nullable_to_non_nullable
as double?,shipDate: freezed == shipDate ? _self.shipDate : shipDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedDeliveryDate: freezed == estimatedDeliveryDate ? _self.estimatedDeliveryDate : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npState: freezed == npState ? _self.npState : npState // ignore: cast_nullable_to_non_nullable
as NpState?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,npStatusUpdatedAt: freezed == npStatusUpdatedAt ? _self.npStatusUpdatedAt : npStatusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NpShipment].
extension NpShipmentPatterns on NpShipment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpShipment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpShipment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpShipment value)  $default,){
final _that = this;
switch (_that) {
case _NpShipment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpShipment value)?  $default,){
final _that = this;
switch (_that) {
case _NpShipment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? recipientLastName,  String? recipientFirstName,  String? recipientMiddleName,  String? recipientPhone, @JsonKey(unknownEnumValue: NpDeliveryType.unknown)  NpDeliveryType? deliveryType,  String? cityRef,  String? cityName,  String? warehouseRef,  String? warehouseName,  String? streetRef,  String? streetName,  String? building,  String? flat, @JsonKey(unknownEnumValue: NpCargoType.unknown)  NpCargoType? cargoType, @JsonKey(unknownEnumValue: NpPayerType.unknown)  NpPayerType? payerType, @JsonKey(unknownEnumValue: NpPaymentMethod.unknown)  NpPaymentMethod? paymentMethod,  double? codAmount,  String? waybillNumber,  DateTime? waybillCreatedAt,  double? waybillCost,  DateTime? shipDate,  DateTime? estimatedDeliveryDate,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpShipment() when $default != null:
return $default(_that.recipientLastName,_that.recipientFirstName,_that.recipientMiddleName,_that.recipientPhone,_that.deliveryType,_that.cityRef,_that.cityName,_that.warehouseRef,_that.warehouseName,_that.streetRef,_that.streetName,_that.building,_that.flat,_that.cargoType,_that.payerType,_that.paymentMethod,_that.codAmount,_that.waybillNumber,_that.waybillCreatedAt,_that.waybillCost,_that.shipDate,_that.estimatedDeliveryDate,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? recipientLastName,  String? recipientFirstName,  String? recipientMiddleName,  String? recipientPhone, @JsonKey(unknownEnumValue: NpDeliveryType.unknown)  NpDeliveryType? deliveryType,  String? cityRef,  String? cityName,  String? warehouseRef,  String? warehouseName,  String? streetRef,  String? streetName,  String? building,  String? flat, @JsonKey(unknownEnumValue: NpCargoType.unknown)  NpCargoType? cargoType, @JsonKey(unknownEnumValue: NpPayerType.unknown)  NpPayerType? payerType, @JsonKey(unknownEnumValue: NpPaymentMethod.unknown)  NpPaymentMethod? paymentMethod,  double? codAmount,  String? waybillNumber,  DateTime? waybillCreatedAt,  double? waybillCost,  DateTime? shipDate,  DateTime? estimatedDeliveryDate,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _NpShipment():
return $default(_that.recipientLastName,_that.recipientFirstName,_that.recipientMiddleName,_that.recipientPhone,_that.deliveryType,_that.cityRef,_that.cityName,_that.warehouseRef,_that.warehouseName,_that.streetRef,_that.streetName,_that.building,_that.flat,_that.cargoType,_that.payerType,_that.paymentMethod,_that.codAmount,_that.waybillNumber,_that.waybillCreatedAt,_that.waybillCost,_that.shipDate,_that.estimatedDeliveryDate,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? recipientLastName,  String? recipientFirstName,  String? recipientMiddleName,  String? recipientPhone, @JsonKey(unknownEnumValue: NpDeliveryType.unknown)  NpDeliveryType? deliveryType,  String? cityRef,  String? cityName,  String? warehouseRef,  String? warehouseName,  String? streetRef,  String? streetName,  String? building,  String? flat, @JsonKey(unknownEnumValue: NpCargoType.unknown)  NpCargoType? cargoType, @JsonKey(unknownEnumValue: NpPayerType.unknown)  NpPayerType? payerType, @JsonKey(unknownEnumValue: NpPaymentMethod.unknown)  NpPaymentMethod? paymentMethod,  double? codAmount,  String? waybillNumber,  DateTime? waybillCreatedAt,  double? waybillCost,  DateTime? shipDate,  DateTime? estimatedDeliveryDate,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _NpShipment() when $default != null:
return $default(_that.recipientLastName,_that.recipientFirstName,_that.recipientMiddleName,_that.recipientPhone,_that.deliveryType,_that.cityRef,_that.cityName,_that.warehouseRef,_that.warehouseName,_that.streetRef,_that.streetName,_that.building,_that.flat,_that.cargoType,_that.payerType,_that.paymentMethod,_that.codAmount,_that.waybillNumber,_that.waybillCreatedAt,_that.waybillCost,_that.shipDate,_that.estimatedDeliveryDate,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpShipment extends NpShipment {
  const _NpShipment({this.recipientLastName, this.recipientFirstName, this.recipientMiddleName, this.recipientPhone, @JsonKey(unknownEnumValue: NpDeliveryType.unknown) this.deliveryType, this.cityRef, this.cityName, this.warehouseRef, this.warehouseName, this.streetRef, this.streetName, this.building, this.flat, @JsonKey(unknownEnumValue: NpCargoType.unknown) this.cargoType, @JsonKey(unknownEnumValue: NpPayerType.unknown) this.payerType, @JsonKey(unknownEnumValue: NpPaymentMethod.unknown) this.paymentMethod, this.codAmount, this.waybillNumber, this.waybillCreatedAt, this.waybillCost, this.shipDate, this.estimatedDeliveryDate, this.npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown) this.npState, this.npStatusText, this.npStatusUpdatedAt}): super._();
  factory _NpShipment.fromJson(Map<String, dynamic> json) => _$NpShipmentFromJson(json);

@override final  String? recipientLastName;
@override final  String? recipientFirstName;
@override final  String? recipientMiddleName;
@override final  String? recipientPhone;
@override@JsonKey(unknownEnumValue: NpDeliveryType.unknown) final  NpDeliveryType? deliveryType;
@override final  String? cityRef;
@override final  String? cityName;
@override final  String? warehouseRef;
@override final  String? warehouseName;
@override final  String? streetRef;
@override final  String? streetName;
@override final  String? building;
@override final  String? flat;
@override@JsonKey(unknownEnumValue: NpCargoType.unknown) final  NpCargoType? cargoType;
@override@JsonKey(unknownEnumValue: NpPayerType.unknown) final  NpPayerType? payerType;
@override@JsonKey(unknownEnumValue: NpPaymentMethod.unknown) final  NpPaymentMethod? paymentMethod;
@override final  double? codAmount;
@override final  String? waybillNumber;
@override final  DateTime? waybillCreatedAt;
@override final  double? waybillCost;
/// Dispatch date written into the waybill: the parcel's trip arrives, plus a day.
@override final  DateTime? shipDate;
@override final  DateTime? estimatedDeliveryDate;
@override final  String? npStatusCode;
@override@JsonKey(unknownEnumValue: NpState.unknown) final  NpState? npState;
@override final  String? npStatusText;
@override final  DateTime? npStatusUpdatedAt;

/// Create a copy of NpShipment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpShipmentCopyWith<_NpShipment> get copyWith => __$NpShipmentCopyWithImpl<_NpShipment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpShipmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpShipment&&(identical(other.recipientLastName, recipientLastName) || other.recipientLastName == recipientLastName)&&(identical(other.recipientFirstName, recipientFirstName) || other.recipientFirstName == recipientFirstName)&&(identical(other.recipientMiddleName, recipientMiddleName) || other.recipientMiddleName == recipientMiddleName)&&(identical(other.recipientPhone, recipientPhone) || other.recipientPhone == recipientPhone)&&(identical(other.deliveryType, deliveryType) || other.deliveryType == deliveryType)&&(identical(other.cityRef, cityRef) || other.cityRef == cityRef)&&(identical(other.cityName, cityName) || other.cityName == cityName)&&(identical(other.warehouseRef, warehouseRef) || other.warehouseRef == warehouseRef)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.streetRef, streetRef) || other.streetRef == streetRef)&&(identical(other.streetName, streetName) || other.streetName == streetName)&&(identical(other.building, building) || other.building == building)&&(identical(other.flat, flat) || other.flat == flat)&&(identical(other.cargoType, cargoType) || other.cargoType == cargoType)&&(identical(other.payerType, payerType) || other.payerType == payerType)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.codAmount, codAmount) || other.codAmount == codAmount)&&(identical(other.waybillNumber, waybillNumber) || other.waybillNumber == waybillNumber)&&(identical(other.waybillCreatedAt, waybillCreatedAt) || other.waybillCreatedAt == waybillCreatedAt)&&(identical(other.waybillCost, waybillCost) || other.waybillCost == waybillCost)&&(identical(other.shipDate, shipDate) || other.shipDate == shipDate)&&(identical(other.estimatedDeliveryDate, estimatedDeliveryDate) || other.estimatedDeliveryDate == estimatedDeliveryDate)&&(identical(other.npStatusCode, npStatusCode) || other.npStatusCode == npStatusCode)&&(identical(other.npState, npState) || other.npState == npState)&&(identical(other.npStatusText, npStatusText) || other.npStatusText == npStatusText)&&(identical(other.npStatusUpdatedAt, npStatusUpdatedAt) || other.npStatusUpdatedAt == npStatusUpdatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,recipientLastName,recipientFirstName,recipientMiddleName,recipientPhone,deliveryType,cityRef,cityName,warehouseRef,warehouseName,streetRef,streetName,building,flat,cargoType,payerType,paymentMethod,codAmount,waybillNumber,waybillCreatedAt,waybillCost,shipDate,estimatedDeliveryDate,npStatusCode,npState,npStatusText,npStatusUpdatedAt]);
}

@override
String toString() {
    return 'NpShipment(recipientLastName: $recipientLastName, recipientFirstName: $recipientFirstName, recipientMiddleName: $recipientMiddleName, recipientPhone: $recipientPhone, deliveryType: $deliveryType, cityRef: $cityRef, cityName: $cityName, warehouseRef: $warehouseRef, warehouseName: $warehouseName, streetRef: $streetRef, streetName: $streetName, building: $building, flat: $flat, cargoType: $cargoType, payerType: $payerType, paymentMethod: $paymentMethod, codAmount: $codAmount, waybillNumber: $waybillNumber, waybillCreatedAt: $waybillCreatedAt, waybillCost: $waybillCost, shipDate: $shipDate, estimatedDeliveryDate: $estimatedDeliveryDate, npStatusCode: $npStatusCode, npState: $npState, npStatusText: $npStatusText, npStatusUpdatedAt: $npStatusUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$NpShipmentCopyWith<$Res> implements $NpShipmentCopyWith<$Res> {
  factory _$NpShipmentCopyWith(_NpShipment value, $Res Function(_NpShipment) _then) = __$NpShipmentCopyWithImpl;
@override @useResult
$Res call({
 String? recipientLastName, String? recipientFirstName, String? recipientMiddleName, String? recipientPhone,@JsonKey(unknownEnumValue: NpDeliveryType.unknown) NpDeliveryType? deliveryType, String? cityRef, String? cityName, String? warehouseRef, String? warehouseName, String? streetRef, String? streetName, String? building, String? flat,@JsonKey(unknownEnumValue: NpCargoType.unknown) NpCargoType? cargoType,@JsonKey(unknownEnumValue: NpPayerType.unknown) NpPayerType? payerType,@JsonKey(unknownEnumValue: NpPaymentMethod.unknown) NpPaymentMethod? paymentMethod, double? codAmount, String? waybillNumber, DateTime? waybillCreatedAt, double? waybillCost, DateTime? shipDate, DateTime? estimatedDeliveryDate, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt
});




}
/// @nodoc
class __$NpShipmentCopyWithImpl<$Res>
    implements _$NpShipmentCopyWith<$Res> {
  __$NpShipmentCopyWithImpl(this._self, this._then);

  final _NpShipment _self;
  final $Res Function(_NpShipment) _then;

/// Create a copy of NpShipment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recipientLastName = freezed,Object? recipientFirstName = freezed,Object? recipientMiddleName = freezed,Object? recipientPhone = freezed,Object? deliveryType = freezed,Object? cityRef = freezed,Object? cityName = freezed,Object? warehouseRef = freezed,Object? warehouseName = freezed,Object? streetRef = freezed,Object? streetName = freezed,Object? building = freezed,Object? flat = freezed,Object? cargoType = freezed,Object? payerType = freezed,Object? paymentMethod = freezed,Object? codAmount = freezed,Object? waybillNumber = freezed,Object? waybillCreatedAt = freezed,Object? waybillCost = freezed,Object? shipDate = freezed,Object? estimatedDeliveryDate = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,}) {
  return _then(_NpShipment(
recipientLastName: freezed == recipientLastName ? _self.recipientLastName : recipientLastName // ignore: cast_nullable_to_non_nullable
as String?,recipientFirstName: freezed == recipientFirstName ? _self.recipientFirstName : recipientFirstName // ignore: cast_nullable_to_non_nullable
as String?,recipientMiddleName: freezed == recipientMiddleName ? _self.recipientMiddleName : recipientMiddleName // ignore: cast_nullable_to_non_nullable
as String?,recipientPhone: freezed == recipientPhone ? _self.recipientPhone : recipientPhone // ignore: cast_nullable_to_non_nullable
as String?,deliveryType: freezed == deliveryType ? _self.deliveryType : deliveryType // ignore: cast_nullable_to_non_nullable
as NpDeliveryType?,cityRef: freezed == cityRef ? _self.cityRef : cityRef // ignore: cast_nullable_to_non_nullable
as String?,cityName: freezed == cityName ? _self.cityName : cityName // ignore: cast_nullable_to_non_nullable
as String?,warehouseRef: freezed == warehouseRef ? _self.warehouseRef : warehouseRef // ignore: cast_nullable_to_non_nullable
as String?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,streetRef: freezed == streetRef ? _self.streetRef : streetRef // ignore: cast_nullable_to_non_nullable
as String?,streetName: freezed == streetName ? _self.streetName : streetName // ignore: cast_nullable_to_non_nullable
as String?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,flat: freezed == flat ? _self.flat : flat // ignore: cast_nullable_to_non_nullable
as String?,cargoType: freezed == cargoType ? _self.cargoType : cargoType // ignore: cast_nullable_to_non_nullable
as NpCargoType?,payerType: freezed == payerType ? _self.payerType : payerType // ignore: cast_nullable_to_non_nullable
as NpPayerType?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as NpPaymentMethod?,codAmount: freezed == codAmount ? _self.codAmount : codAmount // ignore: cast_nullable_to_non_nullable
as double?,waybillNumber: freezed == waybillNumber ? _self.waybillNumber : waybillNumber // ignore: cast_nullable_to_non_nullable
as String?,waybillCreatedAt: freezed == waybillCreatedAt ? _self.waybillCreatedAt : waybillCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waybillCost: freezed == waybillCost ? _self.waybillCost : waybillCost // ignore: cast_nullable_to_non_nullable
as double?,shipDate: freezed == shipDate ? _self.shipDate : shipDate // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedDeliveryDate: freezed == estimatedDeliveryDate ? _self.estimatedDeliveryDate : estimatedDeliveryDate // ignore: cast_nullable_to_non_nullable
as DateTime?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npState: freezed == npState ? _self.npState : npState // ignore: cast_nullable_to_non_nullable
as NpState?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,npStatusUpdatedAt: freezed == npStatusUpdatedAt ? _self.npStatusUpdatedAt : npStatusUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Parcel {

 int get id; String? get barcode;@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? get source;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get status; DateTime? get statusChangedAt; String? get statusChangedBy; bool get needsEnrichment; int? get representativeId; String? get representativeName; int? get clientId; String? get clientName; String? get clientPhone; String? get clientCity; String? get clientAddress; String? get description; double? get weightKg; int? get seatsAmount; double? get lengthCm; double? get widthCm; double? get heightCm; String? get deliveryCity; double? get declaredValue; double? get deliveryPrice; String? get deliveryPriceCurrency;@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? get paymentStatus; DateTime? get paidAt; String? get paidBy;@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? get paymentMethod; String? get senderName; String? get senderPhone; String? get senderCity; String? get notes; String? get npTtn; String? get npPreviousTtn;@JsonKey(unknownEnumValue: Channel.unknown) Channel? get channel; String? get channelDetails; String? get npStatusCode;@JsonKey(unknownEnumValue: NpState.unknown) NpState? get npState; String? get npStatusText; DateTime? get npStatusUpdatedAt; String? get npRecipientWarehouse; DateTime? get npScheduledDeliveryAt; DateTime? get npArrivedAt; DateTime? get npPaidStorageFrom; double? get npDeliveryCost; double? get npCodAmount; String? get npPayerType; String? get npPaymentMethod;/// Nova Poshta's own view of the delivery payment, e.g. `Payed` when it was paid online before pickup.
 String? get npPaymentStatus; double? get npDeliveryAmountDue; double? get npPreviousDeliveryCost; double? get npAmountToPay;/// The parts of [npAmountToPay], as the backend computes them; they always add up to it.
 double? get npDeliveryToPay; double? get npPreviousDeliveryToPay; double? get npCodToPay; double? get npVolumeWeight; List<Seat> get seats; NpShipment? get npShipment; int? get warehouseId; String? get warehouseName; int? get plannedTripId; int? get tripId; int? get plannedTripNumber; int? get tripNumber;/// The route the parcel goes by (a trip in legs) and its number.
 int? get plannedRouteId; int? get plannedRouteNumber;/// The leg number of the trip it is loaded into, or else of the one in its plan.
 int? get tripLegNumber; DateTime? get createdAt;/// Public tracking page of the parcel for the sender or recipient; absent when the company has the option off.
 String? get trackingUrl;@JsonKey(unknownEnumValue: ParcelKind.unknown) ParcelKind? get kind;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Parcel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.barcode, _this.barcode) || other.barcode == _this.barcode)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.statusChangedAt, _this.statusChangedAt) || other.statusChangedAt == _this.statusChangedAt)&&(identical(other.statusChangedBy, _this.statusChangedBy) || other.statusChangedBy == _this.statusChangedBy)&&(identical(other.needsEnrichment, _this.needsEnrichment) || other.needsEnrichment == _this.needsEnrichment)&&(identical(other.representativeId, _this.representativeId) || other.representativeId == _this.representativeId)&&(identical(other.representativeName, _this.representativeName) || other.representativeName == _this.representativeName)&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.clientName, _this.clientName) || other.clientName == _this.clientName)&&(identical(other.clientPhone, _this.clientPhone) || other.clientPhone == _this.clientPhone)&&(identical(other.clientCity, _this.clientCity) || other.clientCity == _this.clientCity)&&(identical(other.clientAddress, _this.clientAddress) || other.clientAddress == _this.clientAddress)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.weightKg, _this.weightKg) || other.weightKg == _this.weightKg)&&(identical(other.seatsAmount, _this.seatsAmount) || other.seatsAmount == _this.seatsAmount)&&(identical(other.lengthCm, _this.lengthCm) || other.lengthCm == _this.lengthCm)&&(identical(other.widthCm, _this.widthCm) || other.widthCm == _this.widthCm)&&(identical(other.heightCm, _this.heightCm) || other.heightCm == _this.heightCm)&&(identical(other.deliveryCity, _this.deliveryCity) || other.deliveryCity == _this.deliveryCity)&&(identical(other.declaredValue, _this.declaredValue) || other.declaredValue == _this.declaredValue)&&(identical(other.deliveryPrice, _this.deliveryPrice) || other.deliveryPrice == _this.deliveryPrice)&&(identical(other.deliveryPriceCurrency, _this.deliveryPriceCurrency) || other.deliveryPriceCurrency == _this.deliveryPriceCurrency)&&(identical(other.paymentStatus, _this.paymentStatus) || other.paymentStatus == _this.paymentStatus)&&(identical(other.paidAt, _this.paidAt) || other.paidAt == _this.paidAt)&&(identical(other.paidBy, _this.paidBy) || other.paidBy == _this.paidBy)&&(identical(other.paymentMethod, _this.paymentMethod) || other.paymentMethod == _this.paymentMethod)&&(identical(other.senderName, _this.senderName) || other.senderName == _this.senderName)&&(identical(other.senderPhone, _this.senderPhone) || other.senderPhone == _this.senderPhone)&&(identical(other.senderCity, _this.senderCity) || other.senderCity == _this.senderCity)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.npTtn, _this.npTtn) || other.npTtn == _this.npTtn)&&(identical(other.npPreviousTtn, _this.npPreviousTtn) || other.npPreviousTtn == _this.npPreviousTtn)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.channelDetails, _this.channelDetails) || other.channelDetails == _this.channelDetails)&&(identical(other.npStatusCode, _this.npStatusCode) || other.npStatusCode == _this.npStatusCode)&&(identical(other.npState, _this.npState) || other.npState == _this.npState)&&(identical(other.npStatusText, _this.npStatusText) || other.npStatusText == _this.npStatusText)&&(identical(other.npStatusUpdatedAt, _this.npStatusUpdatedAt) || other.npStatusUpdatedAt == _this.npStatusUpdatedAt)&&(identical(other.npRecipientWarehouse, _this.npRecipientWarehouse) || other.npRecipientWarehouse == _this.npRecipientWarehouse)&&(identical(other.npScheduledDeliveryAt, _this.npScheduledDeliveryAt) || other.npScheduledDeliveryAt == _this.npScheduledDeliveryAt)&&(identical(other.npArrivedAt, _this.npArrivedAt) || other.npArrivedAt == _this.npArrivedAt)&&(identical(other.npPaidStorageFrom, _this.npPaidStorageFrom) || other.npPaidStorageFrom == _this.npPaidStorageFrom)&&(identical(other.npDeliveryCost, _this.npDeliveryCost) || other.npDeliveryCost == _this.npDeliveryCost)&&(identical(other.npCodAmount, _this.npCodAmount) || other.npCodAmount == _this.npCodAmount)&&(identical(other.npPayerType, _this.npPayerType) || other.npPayerType == _this.npPayerType)&&(identical(other.npPaymentMethod, _this.npPaymentMethod) || other.npPaymentMethod == _this.npPaymentMethod)&&(identical(other.npPaymentStatus, _this.npPaymentStatus) || other.npPaymentStatus == _this.npPaymentStatus)&&(identical(other.npDeliveryAmountDue, _this.npDeliveryAmountDue) || other.npDeliveryAmountDue == _this.npDeliveryAmountDue)&&(identical(other.npPreviousDeliveryCost, _this.npPreviousDeliveryCost) || other.npPreviousDeliveryCost == _this.npPreviousDeliveryCost)&&(identical(other.npAmountToPay, _this.npAmountToPay) || other.npAmountToPay == _this.npAmountToPay)&&(identical(other.npDeliveryToPay, _this.npDeliveryToPay) || other.npDeliveryToPay == _this.npDeliveryToPay)&&(identical(other.npPreviousDeliveryToPay, _this.npPreviousDeliveryToPay) || other.npPreviousDeliveryToPay == _this.npPreviousDeliveryToPay)&&(identical(other.npCodToPay, _this.npCodToPay) || other.npCodToPay == _this.npCodToPay)&&(identical(other.npVolumeWeight, _this.npVolumeWeight) || other.npVolumeWeight == _this.npVolumeWeight)&&const DeepCollectionEquality().equals(other.seats, _this.seats)&&(identical(other.npShipment, _this.npShipment) || other.npShipment == _this.npShipment)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.plannedTripId, _this.plannedTripId) || other.plannedTripId == _this.plannedTripId)&&(identical(other.tripId, _this.tripId) || other.tripId == _this.tripId)&&(identical(other.plannedTripNumber, _this.plannedTripNumber) || other.plannedTripNumber == _this.plannedTripNumber)&&(identical(other.tripNumber, _this.tripNumber) || other.tripNumber == _this.tripNumber)&&(identical(other.plannedRouteId, _this.plannedRouteId) || other.plannedRouteId == _this.plannedRouteId)&&(identical(other.plannedRouteNumber, _this.plannedRouteNumber) || other.plannedRouteNumber == _this.plannedRouteNumber)&&(identical(other.tripLegNumber, _this.tripLegNumber) || other.tripLegNumber == _this.tripLegNumber)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.trackingUrl, _this.trackingUrl) || other.trackingUrl == _this.trackingUrl)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Parcel;
  return Object.hashAll([runtimeType,_this.id,_this.barcode,_this.source,_this.status,_this.statusChangedAt,_this.statusChangedBy,_this.needsEnrichment,_this.representativeId,_this.representativeName,_this.clientId,_this.clientName,_this.clientPhone,_this.clientCity,_this.clientAddress,_this.description,_this.weightKg,_this.seatsAmount,_this.lengthCm,_this.widthCm,_this.heightCm,_this.deliveryCity,_this.declaredValue,_this.deliveryPrice,_this.deliveryPriceCurrency,_this.paymentStatus,_this.paidAt,_this.paidBy,_this.paymentMethod,_this.senderName,_this.senderPhone,_this.senderCity,_this.notes,_this.npTtn,_this.npPreviousTtn,_this.channel,_this.channelDetails,_this.npStatusCode,_this.npState,_this.npStatusText,_this.npStatusUpdatedAt,_this.npRecipientWarehouse,_this.npScheduledDeliveryAt,_this.npArrivedAt,_this.npPaidStorageFrom,_this.npDeliveryCost,_this.npCodAmount,_this.npPayerType,_this.npPaymentMethod,_this.npPaymentStatus,_this.npDeliveryAmountDue,_this.npPreviousDeliveryCost,_this.npAmountToPay,_this.npDeliveryToPay,_this.npPreviousDeliveryToPay,_this.npCodToPay,_this.npVolumeWeight,const DeepCollectionEquality().hash(_this.seats),_this.npShipment,_this.warehouseId,_this.warehouseName,_this.plannedTripId,_this.tripId,_this.plannedTripNumber,_this.tripNumber,_this.plannedRouteId,_this.plannedRouteNumber,_this.tripLegNumber,_this.createdAt,_this.trackingUrl,_this.kind]);
}

@override
String toString() {
  final _this = this as Parcel;
  return 'Parcel(id: ${_this.id}, barcode: ${_this.barcode}, source: ${_this.source}, status: ${_this.status}, statusChangedAt: ${_this.statusChangedAt}, statusChangedBy: ${_this.statusChangedBy}, needsEnrichment: ${_this.needsEnrichment}, representativeId: ${_this.representativeId}, representativeName: ${_this.representativeName}, clientId: ${_this.clientId}, clientName: ${_this.clientName}, clientPhone: ${_this.clientPhone}, clientCity: ${_this.clientCity}, clientAddress: ${_this.clientAddress}, description: ${_this.description}, weightKg: ${_this.weightKg}, seatsAmount: ${_this.seatsAmount}, lengthCm: ${_this.lengthCm}, widthCm: ${_this.widthCm}, heightCm: ${_this.heightCm}, deliveryCity: ${_this.deliveryCity}, declaredValue: ${_this.declaredValue}, deliveryPrice: ${_this.deliveryPrice}, deliveryPriceCurrency: ${_this.deliveryPriceCurrency}, paymentStatus: ${_this.paymentStatus}, paidAt: ${_this.paidAt}, paidBy: ${_this.paidBy}, paymentMethod: ${_this.paymentMethod}, senderName: ${_this.senderName}, senderPhone: ${_this.senderPhone}, senderCity: ${_this.senderCity}, notes: ${_this.notes}, npTtn: ${_this.npTtn}, npPreviousTtn: ${_this.npPreviousTtn}, channel: ${_this.channel}, channelDetails: ${_this.channelDetails}, npStatusCode: ${_this.npStatusCode}, npState: ${_this.npState}, npStatusText: ${_this.npStatusText}, npStatusUpdatedAt: ${_this.npStatusUpdatedAt}, npRecipientWarehouse: ${_this.npRecipientWarehouse}, npScheduledDeliveryAt: ${_this.npScheduledDeliveryAt}, npArrivedAt: ${_this.npArrivedAt}, npPaidStorageFrom: ${_this.npPaidStorageFrom}, npDeliveryCost: ${_this.npDeliveryCost}, npCodAmount: ${_this.npCodAmount}, npPayerType: ${_this.npPayerType}, npPaymentMethod: ${_this.npPaymentMethod}, npPaymentStatus: ${_this.npPaymentStatus}, npDeliveryAmountDue: ${_this.npDeliveryAmountDue}, npPreviousDeliveryCost: ${_this.npPreviousDeliveryCost}, npAmountToPay: ${_this.npAmountToPay}, npDeliveryToPay: ${_this.npDeliveryToPay}, npPreviousDeliveryToPay: ${_this.npPreviousDeliveryToPay}, npCodToPay: ${_this.npCodToPay}, npVolumeWeight: ${_this.npVolumeWeight}, seats: ${_this.seats}, npShipment: ${_this.npShipment}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName}, plannedTripId: ${_this.plannedTripId}, tripId: ${_this.tripId}, plannedTripNumber: ${_this.plannedTripNumber}, tripNumber: ${_this.tripNumber}, plannedRouteId: ${_this.plannedRouteId}, plannedRouteNumber: ${_this.plannedRouteNumber}, tripLegNumber: ${_this.tripLegNumber}, createdAt: ${_this.createdAt}, trackingUrl: ${_this.trackingUrl}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $ParcelCopyWith<$Res>  {
  factory $ParcelCopyWith(Parcel value, $Res Function(Parcel) _then) = _$ParcelCopyWithImpl;
@useResult
$Res call({
 int id, String? barcode,@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? source,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, bool needsEnrichment, int? representativeId, String? representativeName, int? clientId, String? clientName, String? clientPhone, String? clientCity, String? clientAddress, String? description, double? weightKg, int? seatsAmount, double? lengthCm, double? widthCm, double? heightCm, String? deliveryCity, double? declaredValue, double? deliveryPrice, String? deliveryPriceCurrency,@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? paymentStatus, DateTime? paidAt, String? paidBy,@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? paymentMethod, String? senderName, String? senderPhone, String? senderCity, String? notes, String? npTtn, String? npPreviousTtn,@JsonKey(unknownEnumValue: Channel.unknown) Channel? channel, String? channelDetails, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt, String? npRecipientWarehouse, DateTime? npScheduledDeliveryAt, DateTime? npArrivedAt, DateTime? npPaidStorageFrom, double? npDeliveryCost, double? npCodAmount, String? npPayerType, String? npPaymentMethod, String? npPaymentStatus, double? npDeliveryAmountDue, double? npPreviousDeliveryCost, double? npAmountToPay, double? npDeliveryToPay, double? npPreviousDeliveryToPay, double? npCodToPay, double? npVolumeWeight, List<Seat> seats, NpShipment? npShipment, int? warehouseId, String? warehouseName, int? plannedTripId, int? tripId, int? plannedTripNumber, int? tripNumber, int? plannedRouteId, int? plannedRouteNumber, int? tripLegNumber, DateTime? createdAt, String? trackingUrl,@JsonKey(unknownEnumValue: ParcelKind.unknown) ParcelKind? kind
});


$NpShipmentCopyWith<$Res>? get npShipment;

}
/// @nodoc
class _$ParcelCopyWithImpl<$Res>
    implements $ParcelCopyWith<$Res> {
  _$ParcelCopyWithImpl(this._self, this._then);

  final Parcel _self;
  final $Res Function(Parcel) _then;

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? barcode = freezed,Object? source = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? needsEnrichment = null,Object? representativeId = freezed,Object? representativeName = freezed,Object? clientId = freezed,Object? clientName = freezed,Object? clientPhone = freezed,Object? clientCity = freezed,Object? clientAddress = freezed,Object? description = freezed,Object? weightKg = freezed,Object? seatsAmount = freezed,Object? lengthCm = freezed,Object? widthCm = freezed,Object? heightCm = freezed,Object? deliveryCity = freezed,Object? declaredValue = freezed,Object? deliveryPrice = freezed,Object? deliveryPriceCurrency = freezed,Object? paymentStatus = freezed,Object? paidAt = freezed,Object? paidBy = freezed,Object? paymentMethod = freezed,Object? senderName = freezed,Object? senderPhone = freezed,Object? senderCity = freezed,Object? notes = freezed,Object? npTtn = freezed,Object? npPreviousTtn = freezed,Object? channel = freezed,Object? channelDetails = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,Object? npRecipientWarehouse = freezed,Object? npScheduledDeliveryAt = freezed,Object? npArrivedAt = freezed,Object? npPaidStorageFrom = freezed,Object? npDeliveryCost = freezed,Object? npCodAmount = freezed,Object? npPayerType = freezed,Object? npPaymentMethod = freezed,Object? npPaymentStatus = freezed,Object? npDeliveryAmountDue = freezed,Object? npPreviousDeliveryCost = freezed,Object? npAmountToPay = freezed,Object? npDeliveryToPay = freezed,Object? npPreviousDeliveryToPay = freezed,Object? npCodToPay = freezed,Object? npVolumeWeight = freezed,Object? seats = null,Object? npShipment = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? plannedTripId = freezed,Object? tripId = freezed,Object? plannedTripNumber = freezed,Object? tripNumber = freezed,Object? plannedRouteId = freezed,Object? plannedRouteNumber = freezed,Object? tripLegNumber = freezed,Object? createdAt = freezed,Object? trackingUrl = freezed,Object? kind = freezed,}) {
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
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderPhone: freezed == senderPhone ? _self.senderPhone : senderPhone // ignore: cast_nullable_to_non_nullable
as String?,senderCity: freezed == senderCity ? _self.senderCity : senderCity // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,npTtn: freezed == npTtn ? _self.npTtn : npTtn // ignore: cast_nullable_to_non_nullable
as String?,npPreviousTtn: freezed == npPreviousTtn ? _self.npPreviousTtn : npPreviousTtn // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,channelDetails: freezed == channelDetails ? _self.channelDetails : channelDetails // ignore: cast_nullable_to_non_nullable
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
as String?,npPaymentStatus: freezed == npPaymentStatus ? _self.npPaymentStatus : npPaymentStatus // ignore: cast_nullable_to_non_nullable
as String?,npDeliveryAmountDue: freezed == npDeliveryAmountDue ? _self.npDeliveryAmountDue : npDeliveryAmountDue // ignore: cast_nullable_to_non_nullable
as double?,npPreviousDeliveryCost: freezed == npPreviousDeliveryCost ? _self.npPreviousDeliveryCost : npPreviousDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npAmountToPay: freezed == npAmountToPay ? _self.npAmountToPay : npAmountToPay // ignore: cast_nullable_to_non_nullable
as double?,npDeliveryToPay: freezed == npDeliveryToPay ? _self.npDeliveryToPay : npDeliveryToPay // ignore: cast_nullable_to_non_nullable
as double?,npPreviousDeliveryToPay: freezed == npPreviousDeliveryToPay ? _self.npPreviousDeliveryToPay : npPreviousDeliveryToPay // ignore: cast_nullable_to_non_nullable
as double?,npCodToPay: freezed == npCodToPay ? _self.npCodToPay : npCodToPay // ignore: cast_nullable_to_non_nullable
as double?,npVolumeWeight: freezed == npVolumeWeight ? _self.npVolumeWeight : npVolumeWeight // ignore: cast_nullable_to_non_nullable
as double?,seats: null == seats ? _self.seats : seats // ignore: cast_nullable_to_non_nullable
as List<Seat>,npShipment: freezed == npShipment ? _self.npShipment : npShipment // ignore: cast_nullable_to_non_nullable
as NpShipment?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,plannedTripId: freezed == plannedTripId ? _self.plannedTripId : plannedTripId // ignore: cast_nullable_to_non_nullable
as int?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,plannedTripNumber: freezed == plannedTripNumber ? _self.plannedTripNumber : plannedTripNumber // ignore: cast_nullable_to_non_nullable
as int?,tripNumber: freezed == tripNumber ? _self.tripNumber : tripNumber // ignore: cast_nullable_to_non_nullable
as int?,plannedRouteId: freezed == plannedRouteId ? _self.plannedRouteId : plannedRouteId // ignore: cast_nullable_to_non_nullable
as int?,plannedRouteNumber: freezed == plannedRouteNumber ? _self.plannedRouteNumber : plannedRouteNumber // ignore: cast_nullable_to_non_nullable
as int?,tripLegNumber: freezed == tripLegNumber ? _self.tripLegNumber : tripLegNumber // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trackingUrl: freezed == trackingUrl ? _self.trackingUrl : trackingUrl // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ParcelKind?,
  ));
}
/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NpShipmentCopyWith<$Res>? get npShipment {
    if (_self.npShipment == null) {
    return null;
  }

  return $NpShipmentCopyWith<$Res>(_self.npShipment!, (value) {
    return _then(_self.copyWith(npShipment: value));
  });
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? paymentMethod,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  String? npPaymentStatus,  double? npDeliveryAmountDue,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npDeliveryToPay,  double? npPreviousDeliveryToPay,  double? npCodToPay,  double? npVolumeWeight,  List<Seat> seats,  NpShipment? npShipment,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  int? plannedTripNumber,  int? tripNumber,  int? plannedRouteId,  int? plannedRouteNumber,  int? tripLegNumber,  DateTime? createdAt,  String? trackingUrl, @JsonKey(unknownEnumValue: ParcelKind.unknown)  ParcelKind? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.paymentMethod,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.channel,_that.channelDetails,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPaymentStatus,_that.npDeliveryAmountDue,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npDeliveryToPay,_that.npPreviousDeliveryToPay,_that.npCodToPay,_that.npVolumeWeight,_that.seats,_that.npShipment,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.plannedTripNumber,_that.tripNumber,_that.plannedRouteId,_that.plannedRouteNumber,_that.tripLegNumber,_that.createdAt,_that.trackingUrl,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? paymentMethod,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  String? npPaymentStatus,  double? npDeliveryAmountDue,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npDeliveryToPay,  double? npPreviousDeliveryToPay,  double? npCodToPay,  double? npVolumeWeight,  List<Seat> seats,  NpShipment? npShipment,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  int? plannedTripNumber,  int? tripNumber,  int? plannedRouteId,  int? plannedRouteNumber,  int? tripLegNumber,  DateTime? createdAt,  String? trackingUrl, @JsonKey(unknownEnumValue: ParcelKind.unknown)  ParcelKind? kind)  $default,) {final _that = this;
switch (_that) {
case _Parcel():
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.paymentMethod,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.channel,_that.channelDetails,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPaymentStatus,_that.npDeliveryAmountDue,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npDeliveryToPay,_that.npPreviousDeliveryToPay,_that.npCodToPay,_that.npVolumeWeight,_that.seats,_that.npShipment,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.plannedTripNumber,_that.tripNumber,_that.plannedRouteId,_that.plannedRouteNumber,_that.tripLegNumber,_that.createdAt,_that.trackingUrl,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown)  ParcelSource? source, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  DateTime? statusChangedAt,  String? statusChangedBy,  bool needsEnrichment,  int? representativeId,  String? representativeName,  int? clientId,  String? clientName,  String? clientPhone,  String? clientCity,  String? clientAddress,  String? description,  double? weightKg,  int? seatsAmount,  double? lengthCm,  double? widthCm,  double? heightCm,  String? deliveryCity,  double? declaredValue,  double? deliveryPrice,  String? deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown)  PaymentStatus? paymentStatus,  DateTime? paidAt,  String? paidBy, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? paymentMethod,  String? senderName,  String? senderPhone,  String? senderCity,  String? notes,  String? npTtn,  String? npPreviousTtn, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  String? npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown)  NpState? npState,  String? npStatusText,  DateTime? npStatusUpdatedAt,  String? npRecipientWarehouse,  DateTime? npScheduledDeliveryAt,  DateTime? npArrivedAt,  DateTime? npPaidStorageFrom,  double? npDeliveryCost,  double? npCodAmount,  String? npPayerType,  String? npPaymentMethod,  String? npPaymentStatus,  double? npDeliveryAmountDue,  double? npPreviousDeliveryCost,  double? npAmountToPay,  double? npDeliveryToPay,  double? npPreviousDeliveryToPay,  double? npCodToPay,  double? npVolumeWeight,  List<Seat> seats,  NpShipment? npShipment,  int? warehouseId,  String? warehouseName,  int? plannedTripId,  int? tripId,  int? plannedTripNumber,  int? tripNumber,  int? plannedRouteId,  int? plannedRouteNumber,  int? tripLegNumber,  DateTime? createdAt,  String? trackingUrl, @JsonKey(unknownEnumValue: ParcelKind.unknown)  ParcelKind? kind)?  $default,) {final _that = this;
switch (_that) {
case _Parcel() when $default != null:
return $default(_that.id,_that.barcode,_that.source,_that.status,_that.statusChangedAt,_that.statusChangedBy,_that.needsEnrichment,_that.representativeId,_that.representativeName,_that.clientId,_that.clientName,_that.clientPhone,_that.clientCity,_that.clientAddress,_that.description,_that.weightKg,_that.seatsAmount,_that.lengthCm,_that.widthCm,_that.heightCm,_that.deliveryCity,_that.declaredValue,_that.deliveryPrice,_that.deliveryPriceCurrency,_that.paymentStatus,_that.paidAt,_that.paidBy,_that.paymentMethod,_that.senderName,_that.senderPhone,_that.senderCity,_that.notes,_that.npTtn,_that.npPreviousTtn,_that.channel,_that.channelDetails,_that.npStatusCode,_that.npState,_that.npStatusText,_that.npStatusUpdatedAt,_that.npRecipientWarehouse,_that.npScheduledDeliveryAt,_that.npArrivedAt,_that.npPaidStorageFrom,_that.npDeliveryCost,_that.npCodAmount,_that.npPayerType,_that.npPaymentMethod,_that.npPaymentStatus,_that.npDeliveryAmountDue,_that.npPreviousDeliveryCost,_that.npAmountToPay,_that.npDeliveryToPay,_that.npPreviousDeliveryToPay,_that.npCodToPay,_that.npVolumeWeight,_that.seats,_that.npShipment,_that.warehouseId,_that.warehouseName,_that.plannedTripId,_that.tripId,_that.plannedTripNumber,_that.tripNumber,_that.plannedRouteId,_that.plannedRouteNumber,_that.tripLegNumber,_that.createdAt,_that.trackingUrl,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Parcel extends Parcel {
  const _Parcel({required this.id, this.barcode, @JsonKey(unknownEnumValue: ParcelSource.unknown) this.source, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.status, this.statusChangedAt, this.statusChangedBy, this.needsEnrichment = false, this.representativeId, this.representativeName, this.clientId, this.clientName, this.clientPhone, this.clientCity, this.clientAddress, this.description, this.weightKg, this.seatsAmount, this.lengthCm, this.widthCm, this.heightCm, this.deliveryCity, this.declaredValue, this.deliveryPrice, this.deliveryPriceCurrency, @JsonKey(unknownEnumValue: PaymentStatus.unknown) this.paymentStatus, this.paidAt, this.paidBy, @JsonKey(unknownEnumValue: PaymentMethod.unknown) this.paymentMethod, this.senderName, this.senderPhone, this.senderCity, this.notes, this.npTtn, this.npPreviousTtn, @JsonKey(unknownEnumValue: Channel.unknown) this.channel, this.channelDetails, this.npStatusCode, @JsonKey(unknownEnumValue: NpState.unknown) this.npState, this.npStatusText, this.npStatusUpdatedAt, this.npRecipientWarehouse, this.npScheduledDeliveryAt, this.npArrivedAt, this.npPaidStorageFrom, this.npDeliveryCost, this.npCodAmount, this.npPayerType, this.npPaymentMethod, this.npPaymentStatus, this.npDeliveryAmountDue, this.npPreviousDeliveryCost, this.npAmountToPay, this.npDeliveryToPay, this.npPreviousDeliveryToPay, this.npCodToPay, this.npVolumeWeight,  List<Seat> seats = const [], this.npShipment, this.warehouseId, this.warehouseName, this.plannedTripId, this.tripId, this.plannedTripNumber, this.tripNumber, this.plannedRouteId, this.plannedRouteNumber, this.tripLegNumber, this.createdAt, this.trackingUrl, @JsonKey(unknownEnumValue: ParcelKind.unknown) this.kind}): _seats = seats,super._();
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
@override@JsonKey(unknownEnumValue: PaymentMethod.unknown) final  PaymentMethod? paymentMethod;
@override final  String? senderName;
@override final  String? senderPhone;
@override final  String? senderCity;
@override final  String? notes;
@override final  String? npTtn;
@override final  String? npPreviousTtn;
@override@JsonKey(unknownEnumValue: Channel.unknown) final  Channel? channel;
@override final  String? channelDetails;
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
/// Nova Poshta's own view of the delivery payment, e.g. `Payed` when it was paid online before pickup.
@override final  String? npPaymentStatus;
@override final  double? npDeliveryAmountDue;
@override final  double? npPreviousDeliveryCost;
@override final  double? npAmountToPay;
/// The parts of [npAmountToPay], as the backend computes them; they always add up to it.
@override final  double? npDeliveryToPay;
@override final  double? npPreviousDeliveryToPay;
@override final  double? npCodToPay;
@override final  double? npVolumeWeight;
 final  List<Seat> _seats;
@override@JsonKey() List<Seat> get seats {
  if (_seats is EqualUnmodifiableListView) return _seats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seats);
}

@override final  NpShipment? npShipment;
@override final  int? warehouseId;
@override final  String? warehouseName;
@override final  int? plannedTripId;
@override final  int? tripId;
@override final  int? plannedTripNumber;
@override final  int? tripNumber;
/// The route the parcel goes by (a trip in legs) and its number.
@override final  int? plannedRouteId;
@override final  int? plannedRouteNumber;
/// The leg number of the trip it is loaded into, or else of the one in its plan.
@override final  int? tripLegNumber;
@override final  DateTime? createdAt;
/// Public tracking page of the parcel for the sender or recipient; absent when the company has the option off.
@override final  String? trackingUrl;
@override@JsonKey(unknownEnumValue: ParcelKind.unknown) final  ParcelKind? kind;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Parcel&&(identical(other.id, id) || other.id == id)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.source, source) || other.source == source)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusChangedAt, statusChangedAt) || other.statusChangedAt == statusChangedAt)&&(identical(other.statusChangedBy, statusChangedBy) || other.statusChangedBy == statusChangedBy)&&(identical(other.needsEnrichment, needsEnrichment) || other.needsEnrichment == needsEnrichment)&&(identical(other.representativeId, representativeId) || other.representativeId == representativeId)&&(identical(other.representativeName, representativeName) || other.representativeName == representativeName)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.clientPhone, clientPhone) || other.clientPhone == clientPhone)&&(identical(other.clientCity, clientCity) || other.clientCity == clientCity)&&(identical(other.clientAddress, clientAddress) || other.clientAddress == clientAddress)&&(identical(other.description, description) || other.description == description)&&(identical(other.weightKg, weightKg) || other.weightKg == weightKg)&&(identical(other.seatsAmount, seatsAmount) || other.seatsAmount == seatsAmount)&&(identical(other.lengthCm, lengthCm) || other.lengthCm == lengthCm)&&(identical(other.widthCm, widthCm) || other.widthCm == widthCm)&&(identical(other.heightCm, heightCm) || other.heightCm == heightCm)&&(identical(other.deliveryCity, deliveryCity) || other.deliveryCity == deliveryCity)&&(identical(other.declaredValue, declaredValue) || other.declaredValue == declaredValue)&&(identical(other.deliveryPrice, deliveryPrice) || other.deliveryPrice == deliveryPrice)&&(identical(other.deliveryPriceCurrency, deliveryPriceCurrency) || other.deliveryPriceCurrency == deliveryPriceCurrency)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.paidAt, paidAt) || other.paidAt == paidAt)&&(identical(other.paidBy, paidBy) || other.paidBy == paidBy)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod)&&(identical(other.senderName, senderName) || other.senderName == senderName)&&(identical(other.senderPhone, senderPhone) || other.senderPhone == senderPhone)&&(identical(other.senderCity, senderCity) || other.senderCity == senderCity)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.npTtn, npTtn) || other.npTtn == npTtn)&&(identical(other.npPreviousTtn, npPreviousTtn) || other.npPreviousTtn == npPreviousTtn)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.channelDetails, channelDetails) || other.channelDetails == channelDetails)&&(identical(other.npStatusCode, npStatusCode) || other.npStatusCode == npStatusCode)&&(identical(other.npState, npState) || other.npState == npState)&&(identical(other.npStatusText, npStatusText) || other.npStatusText == npStatusText)&&(identical(other.npStatusUpdatedAt, npStatusUpdatedAt) || other.npStatusUpdatedAt == npStatusUpdatedAt)&&(identical(other.npRecipientWarehouse, npRecipientWarehouse) || other.npRecipientWarehouse == npRecipientWarehouse)&&(identical(other.npScheduledDeliveryAt, npScheduledDeliveryAt) || other.npScheduledDeliveryAt == npScheduledDeliveryAt)&&(identical(other.npArrivedAt, npArrivedAt) || other.npArrivedAt == npArrivedAt)&&(identical(other.npPaidStorageFrom, npPaidStorageFrom) || other.npPaidStorageFrom == npPaidStorageFrom)&&(identical(other.npDeliveryCost, npDeliveryCost) || other.npDeliveryCost == npDeliveryCost)&&(identical(other.npCodAmount, npCodAmount) || other.npCodAmount == npCodAmount)&&(identical(other.npPayerType, npPayerType) || other.npPayerType == npPayerType)&&(identical(other.npPaymentMethod, npPaymentMethod) || other.npPaymentMethod == npPaymentMethod)&&(identical(other.npPaymentStatus, npPaymentStatus) || other.npPaymentStatus == npPaymentStatus)&&(identical(other.npDeliveryAmountDue, npDeliveryAmountDue) || other.npDeliveryAmountDue == npDeliveryAmountDue)&&(identical(other.npPreviousDeliveryCost, npPreviousDeliveryCost) || other.npPreviousDeliveryCost == npPreviousDeliveryCost)&&(identical(other.npAmountToPay, npAmountToPay) || other.npAmountToPay == npAmountToPay)&&(identical(other.npDeliveryToPay, npDeliveryToPay) || other.npDeliveryToPay == npDeliveryToPay)&&(identical(other.npPreviousDeliveryToPay, npPreviousDeliveryToPay) || other.npPreviousDeliveryToPay == npPreviousDeliveryToPay)&&(identical(other.npCodToPay, npCodToPay) || other.npCodToPay == npCodToPay)&&(identical(other.npVolumeWeight, npVolumeWeight) || other.npVolumeWeight == npVolumeWeight)&&const DeepCollectionEquality().equals(other.seats, _seats)&&(identical(other.npShipment, npShipment) || other.npShipment == npShipment)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.plannedTripId, plannedTripId) || other.plannedTripId == plannedTripId)&&(identical(other.tripId, tripId) || other.tripId == tripId)&&(identical(other.plannedTripNumber, plannedTripNumber) || other.plannedTripNumber == plannedTripNumber)&&(identical(other.tripNumber, tripNumber) || other.tripNumber == tripNumber)&&(identical(other.plannedRouteId, plannedRouteId) || other.plannedRouteId == plannedRouteId)&&(identical(other.plannedRouteNumber, plannedRouteNumber) || other.plannedRouteNumber == plannedRouteNumber)&&(identical(other.tripLegNumber, tripLegNumber) || other.tripLegNumber == tripLegNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.trackingUrl, trackingUrl) || other.trackingUrl == trackingUrl)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,barcode,source,status,statusChangedAt,statusChangedBy,needsEnrichment,representativeId,representativeName,clientId,clientName,clientPhone,clientCity,clientAddress,description,weightKg,seatsAmount,lengthCm,widthCm,heightCm,deliveryCity,declaredValue,deliveryPrice,deliveryPriceCurrency,paymentStatus,paidAt,paidBy,paymentMethod,senderName,senderPhone,senderCity,notes,npTtn,npPreviousTtn,channel,channelDetails,npStatusCode,npState,npStatusText,npStatusUpdatedAt,npRecipientWarehouse,npScheduledDeliveryAt,npArrivedAt,npPaidStorageFrom,npDeliveryCost,npCodAmount,npPayerType,npPaymentMethod,npPaymentStatus,npDeliveryAmountDue,npPreviousDeliveryCost,npAmountToPay,npDeliveryToPay,npPreviousDeliveryToPay,npCodToPay,npVolumeWeight,const DeepCollectionEquality().hash(_seats),npShipment,warehouseId,warehouseName,plannedTripId,tripId,plannedTripNumber,tripNumber,plannedRouteId,plannedRouteNumber,tripLegNumber,createdAt,trackingUrl,kind]);
}

@override
String toString() {
    return 'Parcel(id: $id, barcode: $barcode, source: $source, status: $status, statusChangedAt: $statusChangedAt, statusChangedBy: $statusChangedBy, needsEnrichment: $needsEnrichment, representativeId: $representativeId, representativeName: $representativeName, clientId: $clientId, clientName: $clientName, clientPhone: $clientPhone, clientCity: $clientCity, clientAddress: $clientAddress, description: $description, weightKg: $weightKg, seatsAmount: $seatsAmount, lengthCm: $lengthCm, widthCm: $widthCm, heightCm: $heightCm, deliveryCity: $deliveryCity, declaredValue: $declaredValue, deliveryPrice: $deliveryPrice, deliveryPriceCurrency: $deliveryPriceCurrency, paymentStatus: $paymentStatus, paidAt: $paidAt, paidBy: $paidBy, paymentMethod: $paymentMethod, senderName: $senderName, senderPhone: $senderPhone, senderCity: $senderCity, notes: $notes, npTtn: $npTtn, npPreviousTtn: $npPreviousTtn, channel: $channel, channelDetails: $channelDetails, npStatusCode: $npStatusCode, npState: $npState, npStatusText: $npStatusText, npStatusUpdatedAt: $npStatusUpdatedAt, npRecipientWarehouse: $npRecipientWarehouse, npScheduledDeliveryAt: $npScheduledDeliveryAt, npArrivedAt: $npArrivedAt, npPaidStorageFrom: $npPaidStorageFrom, npDeliveryCost: $npDeliveryCost, npCodAmount: $npCodAmount, npPayerType: $npPayerType, npPaymentMethod: $npPaymentMethod, npPaymentStatus: $npPaymentStatus, npDeliveryAmountDue: $npDeliveryAmountDue, npPreviousDeliveryCost: $npPreviousDeliveryCost, npAmountToPay: $npAmountToPay, npDeliveryToPay: $npDeliveryToPay, npPreviousDeliveryToPay: $npPreviousDeliveryToPay, npCodToPay: $npCodToPay, npVolumeWeight: $npVolumeWeight, seats: $seats, npShipment: $npShipment, warehouseId: $warehouseId, warehouseName: $warehouseName, plannedTripId: $plannedTripId, tripId: $tripId, plannedTripNumber: $plannedTripNumber, tripNumber: $tripNumber, plannedRouteId: $plannedRouteId, plannedRouteNumber: $plannedRouteNumber, tripLegNumber: $tripLegNumber, createdAt: $createdAt, trackingUrl: $trackingUrl, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ParcelCopyWith<$Res> implements $ParcelCopyWith<$Res> {
  factory _$ParcelCopyWith(_Parcel value, $Res Function(_Parcel) _then) = __$ParcelCopyWithImpl;
@override @useResult
$Res call({
 int id, String? barcode,@JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? source,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, DateTime? statusChangedAt, String? statusChangedBy, bool needsEnrichment, int? representativeId, String? representativeName, int? clientId, String? clientName, String? clientPhone, String? clientCity, String? clientAddress, String? description, double? weightKg, int? seatsAmount, double? lengthCm, double? widthCm, double? heightCm, String? deliveryCity, double? declaredValue, double? deliveryPrice, String? deliveryPriceCurrency,@JsonKey(unknownEnumValue: PaymentStatus.unknown) PaymentStatus? paymentStatus, DateTime? paidAt, String? paidBy,@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? paymentMethod, String? senderName, String? senderPhone, String? senderCity, String? notes, String? npTtn, String? npPreviousTtn,@JsonKey(unknownEnumValue: Channel.unknown) Channel? channel, String? channelDetails, String? npStatusCode,@JsonKey(unknownEnumValue: NpState.unknown) NpState? npState, String? npStatusText, DateTime? npStatusUpdatedAt, String? npRecipientWarehouse, DateTime? npScheduledDeliveryAt, DateTime? npArrivedAt, DateTime? npPaidStorageFrom, double? npDeliveryCost, double? npCodAmount, String? npPayerType, String? npPaymentMethod, String? npPaymentStatus, double? npDeliveryAmountDue, double? npPreviousDeliveryCost, double? npAmountToPay, double? npDeliveryToPay, double? npPreviousDeliveryToPay, double? npCodToPay, double? npVolumeWeight, List<Seat> seats, NpShipment? npShipment, int? warehouseId, String? warehouseName, int? plannedTripId, int? tripId, int? plannedTripNumber, int? tripNumber, int? plannedRouteId, int? plannedRouteNumber, int? tripLegNumber, DateTime? createdAt, String? trackingUrl,@JsonKey(unknownEnumValue: ParcelKind.unknown) ParcelKind? kind
});


@override $NpShipmentCopyWith<$Res>? get npShipment;

}
/// @nodoc
class __$ParcelCopyWithImpl<$Res>
    implements _$ParcelCopyWith<$Res> {
  __$ParcelCopyWithImpl(this._self, this._then);

  final _Parcel _self;
  final $Res Function(_Parcel) _then;

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? barcode = freezed,Object? source = freezed,Object? status = freezed,Object? statusChangedAt = freezed,Object? statusChangedBy = freezed,Object? needsEnrichment = null,Object? representativeId = freezed,Object? representativeName = freezed,Object? clientId = freezed,Object? clientName = freezed,Object? clientPhone = freezed,Object? clientCity = freezed,Object? clientAddress = freezed,Object? description = freezed,Object? weightKg = freezed,Object? seatsAmount = freezed,Object? lengthCm = freezed,Object? widthCm = freezed,Object? heightCm = freezed,Object? deliveryCity = freezed,Object? declaredValue = freezed,Object? deliveryPrice = freezed,Object? deliveryPriceCurrency = freezed,Object? paymentStatus = freezed,Object? paidAt = freezed,Object? paidBy = freezed,Object? paymentMethod = freezed,Object? senderName = freezed,Object? senderPhone = freezed,Object? senderCity = freezed,Object? notes = freezed,Object? npTtn = freezed,Object? npPreviousTtn = freezed,Object? channel = freezed,Object? channelDetails = freezed,Object? npStatusCode = freezed,Object? npState = freezed,Object? npStatusText = freezed,Object? npStatusUpdatedAt = freezed,Object? npRecipientWarehouse = freezed,Object? npScheduledDeliveryAt = freezed,Object? npArrivedAt = freezed,Object? npPaidStorageFrom = freezed,Object? npDeliveryCost = freezed,Object? npCodAmount = freezed,Object? npPayerType = freezed,Object? npPaymentMethod = freezed,Object? npPaymentStatus = freezed,Object? npDeliveryAmountDue = freezed,Object? npPreviousDeliveryCost = freezed,Object? npAmountToPay = freezed,Object? npDeliveryToPay = freezed,Object? npPreviousDeliveryToPay = freezed,Object? npCodToPay = freezed,Object? npVolumeWeight = freezed,Object? seats = null,Object? npShipment = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? plannedTripId = freezed,Object? tripId = freezed,Object? plannedTripNumber = freezed,Object? tripNumber = freezed,Object? plannedRouteId = freezed,Object? plannedRouteNumber = freezed,Object? tripLegNumber = freezed,Object? createdAt = freezed,Object? trackingUrl = freezed,Object? kind = freezed,}) {
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
as String?,paymentMethod: freezed == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,senderName: freezed == senderName ? _self.senderName : senderName // ignore: cast_nullable_to_non_nullable
as String?,senderPhone: freezed == senderPhone ? _self.senderPhone : senderPhone // ignore: cast_nullable_to_non_nullable
as String?,senderCity: freezed == senderCity ? _self.senderCity : senderCity // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,npTtn: freezed == npTtn ? _self.npTtn : npTtn // ignore: cast_nullable_to_non_nullable
as String?,npPreviousTtn: freezed == npPreviousTtn ? _self.npPreviousTtn : npPreviousTtn // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,channelDetails: freezed == channelDetails ? _self.channelDetails : channelDetails // ignore: cast_nullable_to_non_nullable
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
as String?,npPaymentStatus: freezed == npPaymentStatus ? _self.npPaymentStatus : npPaymentStatus // ignore: cast_nullable_to_non_nullable
as String?,npDeliveryAmountDue: freezed == npDeliveryAmountDue ? _self.npDeliveryAmountDue : npDeliveryAmountDue // ignore: cast_nullable_to_non_nullable
as double?,npPreviousDeliveryCost: freezed == npPreviousDeliveryCost ? _self.npPreviousDeliveryCost : npPreviousDeliveryCost // ignore: cast_nullable_to_non_nullable
as double?,npAmountToPay: freezed == npAmountToPay ? _self.npAmountToPay : npAmountToPay // ignore: cast_nullable_to_non_nullable
as double?,npDeliveryToPay: freezed == npDeliveryToPay ? _self.npDeliveryToPay : npDeliveryToPay // ignore: cast_nullable_to_non_nullable
as double?,npPreviousDeliveryToPay: freezed == npPreviousDeliveryToPay ? _self.npPreviousDeliveryToPay : npPreviousDeliveryToPay // ignore: cast_nullable_to_non_nullable
as double?,npCodToPay: freezed == npCodToPay ? _self.npCodToPay : npCodToPay // ignore: cast_nullable_to_non_nullable
as double?,npVolumeWeight: freezed == npVolumeWeight ? _self.npVolumeWeight : npVolumeWeight // ignore: cast_nullable_to_non_nullable
as double?,seats: null == seats ? _self._seats : seats // ignore: cast_nullable_to_non_nullable
as List<Seat>,npShipment: freezed == npShipment ? _self.npShipment : npShipment // ignore: cast_nullable_to_non_nullable
as NpShipment?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,plannedTripId: freezed == plannedTripId ? _self.plannedTripId : plannedTripId // ignore: cast_nullable_to_non_nullable
as int?,tripId: freezed == tripId ? _self.tripId : tripId // ignore: cast_nullable_to_non_nullable
as int?,plannedTripNumber: freezed == plannedTripNumber ? _self.plannedTripNumber : plannedTripNumber // ignore: cast_nullable_to_non_nullable
as int?,tripNumber: freezed == tripNumber ? _self.tripNumber : tripNumber // ignore: cast_nullable_to_non_nullable
as int?,plannedRouteId: freezed == plannedRouteId ? _self.plannedRouteId : plannedRouteId // ignore: cast_nullable_to_non_nullable
as int?,plannedRouteNumber: freezed == plannedRouteNumber ? _self.plannedRouteNumber : plannedRouteNumber // ignore: cast_nullable_to_non_nullable
as int?,tripLegNumber: freezed == tripLegNumber ? _self.tripLegNumber : tripLegNumber // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,trackingUrl: freezed == trackingUrl ? _self.trackingUrl : trackingUrl // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ParcelKind?,
  ));
}

/// Create a copy of Parcel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NpShipmentCopyWith<$Res>? get npShipment {
    if (_self.npShipment == null) {
    return null;
  }

  return $NpShipmentCopyWith<$Res>(_self.npShipment!, (value) {
    return _then(_self.copyWith(npShipment: value));
  });
}
}

// dart format on
