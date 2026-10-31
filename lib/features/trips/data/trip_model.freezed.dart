// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trip_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Trip {

 int get id;/// What people see: 1, 2, 3 … within the company; the id stays for requests.
 int? get number;/// The route this trip is a leg of; null — a trip on its own.
 int? get routeId;/// 1, 2, 3 … within the route: the trip shows as «14.2».
 int? get legNumber;@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? get status; int? get carId; String? get carPlateNumber; int? get driverId; String? get driverName; int? get coDriverId; String? get coDriverName; DateTime? get plannedDepartureAt; DateTime? get plannedArrivalAt; String? get origin; String? get destination; String? get notes; DateTime? get departedAt; DateTime? get arrivedAt; int? get startOdometerKm; int? get endOdometerKm; int get plannedCount; int get loadedCount; int get deliveredCount; TripPayments? get payments;
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripCopyWith<Trip> get copyWith => _$TripCopyWithImpl<Trip>(this as Trip, _$identity);

  /// Serializes this Trip to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Trip;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.routeId, _this.routeId) || other.routeId == _this.routeId)&&(identical(other.legNumber, _this.legNumber) || other.legNumber == _this.legNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.carId, _this.carId) || other.carId == _this.carId)&&(identical(other.carPlateNumber, _this.carPlateNumber) || other.carPlateNumber == _this.carPlateNumber)&&(identical(other.driverId, _this.driverId) || other.driverId == _this.driverId)&&(identical(other.driverName, _this.driverName) || other.driverName == _this.driverName)&&(identical(other.coDriverId, _this.coDriverId) || other.coDriverId == _this.coDriverId)&&(identical(other.coDriverName, _this.coDriverName) || other.coDriverName == _this.coDriverName)&&(identical(other.plannedDepartureAt, _this.plannedDepartureAt) || other.plannedDepartureAt == _this.plannedDepartureAt)&&(identical(other.plannedArrivalAt, _this.plannedArrivalAt) || other.plannedArrivalAt == _this.plannedArrivalAt)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.departedAt, _this.departedAt) || other.departedAt == _this.departedAt)&&(identical(other.arrivedAt, _this.arrivedAt) || other.arrivedAt == _this.arrivedAt)&&(identical(other.startOdometerKm, _this.startOdometerKm) || other.startOdometerKm == _this.startOdometerKm)&&(identical(other.endOdometerKm, _this.endOdometerKm) || other.endOdometerKm == _this.endOdometerKm)&&(identical(other.plannedCount, _this.plannedCount) || other.plannedCount == _this.plannedCount)&&(identical(other.loadedCount, _this.loadedCount) || other.loadedCount == _this.loadedCount)&&(identical(other.deliveredCount, _this.deliveredCount) || other.deliveredCount == _this.deliveredCount)&&(identical(other.payments, _this.payments) || other.payments == _this.payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Trip;
  return Object.hashAll([runtimeType,_this.id,_this.number,_this.routeId,_this.legNumber,_this.status,_this.carId,_this.carPlateNumber,_this.driverId,_this.driverName,_this.coDriverId,_this.coDriverName,_this.plannedDepartureAt,_this.plannedArrivalAt,_this.origin,_this.destination,_this.notes,_this.departedAt,_this.arrivedAt,_this.startOdometerKm,_this.endOdometerKm,_this.plannedCount,_this.loadedCount,_this.deliveredCount,_this.payments]);
}

@override
String toString() {
  final _this = this as Trip;
  return 'Trip(id: ${_this.id}, number: ${_this.number}, routeId: ${_this.routeId}, legNumber: ${_this.legNumber}, status: ${_this.status}, carId: ${_this.carId}, carPlateNumber: ${_this.carPlateNumber}, driverId: ${_this.driverId}, driverName: ${_this.driverName}, coDriverId: ${_this.coDriverId}, coDriverName: ${_this.coDriverName}, plannedDepartureAt: ${_this.plannedDepartureAt}, plannedArrivalAt: ${_this.plannedArrivalAt}, origin: ${_this.origin}, destination: ${_this.destination}, notes: ${_this.notes}, departedAt: ${_this.departedAt}, arrivedAt: ${_this.arrivedAt}, startOdometerKm: ${_this.startOdometerKm}, endOdometerKm: ${_this.endOdometerKm}, plannedCount: ${_this.plannedCount}, loadedCount: ${_this.loadedCount}, deliveredCount: ${_this.deliveredCount}, payments: ${_this.payments})';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 int id, int? number, int? routeId, int? legNumber,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? carId, String? carPlateNumber, int? driverId, String? driverName, int? coDriverId, String? coDriverName, DateTime? plannedDepartureAt, DateTime? plannedArrivalAt, String? origin, String? destination, String? notes, DateTime? departedAt, DateTime? arrivedAt, int? startOdometerKm, int? endOdometerKm, int plannedCount, int loadedCount, int deliveredCount, TripPayments? payments
});


$TripPaymentsCopyWith<$Res>? get payments;

}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? number = freezed,Object? routeId = freezed,Object? legNumber = freezed,Object? status = freezed,Object? carId = freezed,Object? carPlateNumber = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? coDriverId = freezed,Object? coDriverName = freezed,Object? plannedDepartureAt = freezed,Object? plannedArrivalAt = freezed,Object? origin = freezed,Object? destination = freezed,Object? notes = freezed,Object? departedAt = freezed,Object? arrivedAt = freezed,Object? startOdometerKm = freezed,Object? endOdometerKm = freezed,Object? plannedCount = null,Object? loadedCount = null,Object? deliveredCount = null,Object? payments = freezed,}) {
  return _then(Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as int?,legNumber: freezed == legNumber ? _self.legNumber : legNumber // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,carId: freezed == carId ? _self.carId : carId // ignore: cast_nullable_to_non_nullable
as int?,carPlateNumber: freezed == carPlateNumber ? _self.carPlateNumber : carPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,coDriverId: freezed == coDriverId ? _self.coDriverId : coDriverId // ignore: cast_nullable_to_non_nullable
as int?,coDriverName: freezed == coDriverName ? _self.coDriverName : coDriverName // ignore: cast_nullable_to_non_nullable
as String?,plannedDepartureAt: freezed == plannedDepartureAt ? _self.plannedDepartureAt : plannedDepartureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedArrivalAt: freezed == plannedArrivalAt ? _self.plannedArrivalAt : plannedArrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,departedAt: freezed == departedAt ? _self.departedAt : departedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startOdometerKm: freezed == startOdometerKm ? _self.startOdometerKm : startOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,endOdometerKm: freezed == endOdometerKm ? _self.endOdometerKm : endOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,plannedCount: null == plannedCount ? _self.plannedCount : plannedCount // ignore: cast_nullable_to_non_nullable
as int,loadedCount: null == loadedCount ? _self.loadedCount : loadedCount // ignore: cast_nullable_to_non_nullable
as int,deliveredCount: null == deliveredCount ? _self.deliveredCount : deliveredCount // ignore: cast_nullable_to_non_nullable
as int,payments: freezed == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as TripPayments?,
  ));
}
/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripPaymentsCopyWith<$Res>? get payments {
    if (_self.payments == null) {
    return null;
  }

  return $TripPaymentsCopyWith<$Res>(_self.payments!, (value) {
    return _then(_self.copyWith(payments: value));
  });
}
}


/// Adds pattern-matching-related methods to [Trip].
extension TripPatterns on Trip {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trip value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trip value)  $default,){
final _that = this;
switch (_that) {
case _Trip():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trip value)?  $default,){
final _that = this;
switch (_that) {
case _Trip() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? number,  int? routeId,  int? legNumber, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  int? coDriverId,  String? coDriverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm,  int plannedCount,  int loadedCount,  int deliveredCount,  TripPayments? payments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.number,_that.routeId,_that.legNumber,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.coDriverId,_that.coDriverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm,_that.plannedCount,_that.loadedCount,_that.deliveredCount,_that.payments);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? number,  int? routeId,  int? legNumber, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  int? coDriverId,  String? coDriverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm,  int plannedCount,  int loadedCount,  int deliveredCount,  TripPayments? payments)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.number,_that.routeId,_that.legNumber,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.coDriverId,_that.coDriverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm,_that.plannedCount,_that.loadedCount,_that.deliveredCount,_that.payments);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? number,  int? routeId,  int? legNumber, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  int? coDriverId,  String? coDriverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm,  int plannedCount,  int loadedCount,  int deliveredCount,  TripPayments? payments)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.number,_that.routeId,_that.legNumber,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.coDriverId,_that.coDriverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm,_that.plannedCount,_that.loadedCount,_that.deliveredCount,_that.payments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip extends Trip {
  const _Trip({required this.id, this.number, this.routeId, this.legNumber, @JsonKey(unknownEnumValue: TripStatus.unknown) this.status, this.carId, this.carPlateNumber, this.driverId, this.driverName, this.coDriverId, this.coDriverName, this.plannedDepartureAt, this.plannedArrivalAt, this.origin, this.destination, this.notes, this.departedAt, this.arrivedAt, this.startOdometerKm, this.endOdometerKm, this.plannedCount = 0, this.loadedCount = 0, this.deliveredCount = 0, this.payments}): super._();
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  int id;
/// What people see: 1, 2, 3 … within the company; the id stays for requests.
@override final  int? number;
/// The route this trip is a leg of; null — a trip on its own.
@override final  int? routeId;
/// 1, 2, 3 … within the route: the trip shows as «14.2».
@override final  int? legNumber;
@override@JsonKey(unknownEnumValue: TripStatus.unknown) final  TripStatus? status;
@override final  int? carId;
@override final  String? carPlateNumber;
@override final  int? driverId;
@override final  String? driverName;
@override final  int? coDriverId;
@override final  String? coDriverName;
@override final  DateTime? plannedDepartureAt;
@override final  DateTime? plannedArrivalAt;
@override final  String? origin;
@override final  String? destination;
@override final  String? notes;
@override final  DateTime? departedAt;
@override final  DateTime? arrivedAt;
@override final  int? startOdometerKm;
@override final  int? endOdometerKm;
@override@JsonKey() final  int plannedCount;
@override@JsonKey() final  int loadedCount;
@override@JsonKey() final  int deliveredCount;
@override final  TripPayments? payments;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripCopyWith<_Trip> get copyWith => __$TripCopyWithImpl<_Trip>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.number, number) || other.number == number)&&(identical(other.routeId, routeId) || other.routeId == routeId)&&(identical(other.legNumber, legNumber) || other.legNumber == legNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.carId, carId) || other.carId == carId)&&(identical(other.carPlateNumber, carPlateNumber) || other.carPlateNumber == carPlateNumber)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.coDriverId, coDriverId) || other.coDriverId == coDriverId)&&(identical(other.coDriverName, coDriverName) || other.coDriverName == coDriverName)&&(identical(other.plannedDepartureAt, plannedDepartureAt) || other.plannedDepartureAt == plannedDepartureAt)&&(identical(other.plannedArrivalAt, plannedArrivalAt) || other.plannedArrivalAt == plannedArrivalAt)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.departedAt, departedAt) || other.departedAt == departedAt)&&(identical(other.arrivedAt, arrivedAt) || other.arrivedAt == arrivedAt)&&(identical(other.startOdometerKm, startOdometerKm) || other.startOdometerKm == startOdometerKm)&&(identical(other.endOdometerKm, endOdometerKm) || other.endOdometerKm == endOdometerKm)&&(identical(other.plannedCount, plannedCount) || other.plannedCount == plannedCount)&&(identical(other.loadedCount, loadedCount) || other.loadedCount == loadedCount)&&(identical(other.deliveredCount, deliveredCount) || other.deliveredCount == deliveredCount)&&(identical(other.payments, payments) || other.payments == payments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,number,routeId,legNumber,status,carId,carPlateNumber,driverId,driverName,coDriverId,coDriverName,plannedDepartureAt,plannedArrivalAt,origin,destination,notes,departedAt,arrivedAt,startOdometerKm,endOdometerKm,plannedCount,loadedCount,deliveredCount,payments]);
}

@override
String toString() {
    return 'Trip(id: $id, number: $number, routeId: $routeId, legNumber: $legNumber, status: $status, carId: $carId, carPlateNumber: $carPlateNumber, driverId: $driverId, driverName: $driverName, coDriverId: $coDriverId, coDriverName: $coDriverName, plannedDepartureAt: $plannedDepartureAt, plannedArrivalAt: $plannedArrivalAt, origin: $origin, destination: $destination, notes: $notes, departedAt: $departedAt, arrivedAt: $arrivedAt, startOdometerKm: $startOdometerKm, endOdometerKm: $endOdometerKm, plannedCount: $plannedCount, loadedCount: $loadedCount, deliveredCount: $deliveredCount, payments: $payments)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 int id, int? number, int? routeId, int? legNumber,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? carId, String? carPlateNumber, int? driverId, String? driverName, int? coDriverId, String? coDriverName, DateTime? plannedDepartureAt, DateTime? plannedArrivalAt, String? origin, String? destination, String? notes, DateTime? departedAt, DateTime? arrivedAt, int? startOdometerKm, int? endOdometerKm, int plannedCount, int loadedCount, int deliveredCount, TripPayments? payments
});


@override $TripPaymentsCopyWith<$Res>? get payments;

}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? number = freezed,Object? routeId = freezed,Object? legNumber = freezed,Object? status = freezed,Object? carId = freezed,Object? carPlateNumber = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? coDriverId = freezed,Object? coDriverName = freezed,Object? plannedDepartureAt = freezed,Object? plannedArrivalAt = freezed,Object? origin = freezed,Object? destination = freezed,Object? notes = freezed,Object? departedAt = freezed,Object? arrivedAt = freezed,Object? startOdometerKm = freezed,Object? endOdometerKm = freezed,Object? plannedCount = null,Object? loadedCount = null,Object? deliveredCount = null,Object? payments = freezed,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int?,routeId: freezed == routeId ? _self.routeId : routeId // ignore: cast_nullable_to_non_nullable
as int?,legNumber: freezed == legNumber ? _self.legNumber : legNumber // ignore: cast_nullable_to_non_nullable
as int?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,carId: freezed == carId ? _self.carId : carId // ignore: cast_nullable_to_non_nullable
as int?,carPlateNumber: freezed == carPlateNumber ? _self.carPlateNumber : carPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,coDriverId: freezed == coDriverId ? _self.coDriverId : coDriverId // ignore: cast_nullable_to_non_nullable
as int?,coDriverName: freezed == coDriverName ? _self.coDriverName : coDriverName // ignore: cast_nullable_to_non_nullable
as String?,plannedDepartureAt: freezed == plannedDepartureAt ? _self.plannedDepartureAt : plannedDepartureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedArrivalAt: freezed == plannedArrivalAt ? _self.plannedArrivalAt : plannedArrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,departedAt: freezed == departedAt ? _self.departedAt : departedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startOdometerKm: freezed == startOdometerKm ? _self.startOdometerKm : startOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,endOdometerKm: freezed == endOdometerKm ? _self.endOdometerKm : endOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,plannedCount: null == plannedCount ? _self.plannedCount : plannedCount // ignore: cast_nullable_to_non_nullable
as int,loadedCount: null == loadedCount ? _self.loadedCount : loadedCount // ignore: cast_nullable_to_non_nullable
as int,deliveredCount: null == deliveredCount ? _self.deliveredCount : deliveredCount // ignore: cast_nullable_to_non_nullable
as int,payments: freezed == payments ? _self.payments : payments // ignore: cast_nullable_to_non_nullable
as TripPayments?,
  ));
}

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TripPaymentsCopyWith<$Res>? get payments {
    if (_self.payments == null) {
    return null;
  }

  return $TripPaymentsCopyWith<$Res>(_self.payments!, (value) {
    return _then(_self.copyWith(payments: value));
  });
}
}


/// @nodoc
mixin _$TripPayments {

 List<TripPaymentLine> get received; List<TripPaymentLine> get notReceived;
/// Create a copy of TripPayments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripPaymentsCopyWith<TripPayments> get copyWith => _$TripPaymentsCopyWithImpl<TripPayments>(this as TripPayments, _$identity);

  /// Serializes this TripPayments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripPayments;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripPayments&&const DeepCollectionEquality().equals(other.received, _this.received)&&const DeepCollectionEquality().equals(other.notReceived, _this.notReceived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripPayments;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.received),const DeepCollectionEquality().hash(_this.notReceived));
}

@override
String toString() {
  final _this = this as TripPayments;
  return 'TripPayments(received: ${_this.received}, notReceived: ${_this.notReceived})';
}


}

/// @nodoc
abstract mixin class $TripPaymentsCopyWith<$Res>  {
  factory $TripPaymentsCopyWith(TripPayments value, $Res Function(TripPayments) _then) = _$TripPaymentsCopyWithImpl;
@useResult
$Res call({
 List<TripPaymentLine> received, List<TripPaymentLine> notReceived
});




}
/// @nodoc
class _$TripPaymentsCopyWithImpl<$Res>
    implements $TripPaymentsCopyWith<$Res> {
  _$TripPaymentsCopyWithImpl(this._self, this._then);

  final TripPayments _self;
  final $Res Function(TripPayments) _then;

/// Create a copy of TripPayments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? received = null,Object? notReceived = null,}) {
  return _then(TripPayments(
received: null == received ? _self.received : received // ignore: cast_nullable_to_non_nullable
as List<TripPaymentLine>,notReceived: null == notReceived ? _self.notReceived : notReceived // ignore: cast_nullable_to_non_nullable
as List<TripPaymentLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [TripPayments].
extension TripPaymentsPatterns on TripPayments {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripPayments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripPayments() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripPayments value)  $default,){
final _that = this;
switch (_that) {
case _TripPayments():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripPayments value)?  $default,){
final _that = this;
switch (_that) {
case _TripPayments() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TripPaymentLine> received,  List<TripPaymentLine> notReceived)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripPayments() when $default != null:
return $default(_that.received,_that.notReceived);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TripPaymentLine> received,  List<TripPaymentLine> notReceived)  $default,) {final _that = this;
switch (_that) {
case _TripPayments():
return $default(_that.received,_that.notReceived);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TripPaymentLine> received,  List<TripPaymentLine> notReceived)?  $default,) {final _that = this;
switch (_that) {
case _TripPayments() when $default != null:
return $default(_that.received,_that.notReceived);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripPayments extends TripPayments {
  const _TripPayments({ List<TripPaymentLine> received = const [],  List<TripPaymentLine> notReceived = const []}): _received = received,_notReceived = notReceived,super._();
  factory _TripPayments.fromJson(Map<String, dynamic> json) => _$TripPaymentsFromJson(json);

 final  List<TripPaymentLine> _received;
@override@JsonKey() List<TripPaymentLine> get received {
  if (_received is EqualUnmodifiableListView) return _received;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_received);
}

 final  List<TripPaymentLine> _notReceived;
@override@JsonKey() List<TripPaymentLine> get notReceived {
  if (_notReceived is EqualUnmodifiableListView) return _notReceived;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_notReceived);
}


/// Create a copy of TripPayments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripPaymentsCopyWith<_TripPayments> get copyWith => __$TripPaymentsCopyWithImpl<_TripPayments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripPaymentsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripPayments&&const DeepCollectionEquality().equals(other.received, _received)&&const DeepCollectionEquality().equals(other.notReceived, _notReceived));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_received),const DeepCollectionEquality().hash(_notReceived));
}

@override
String toString() {
    return 'TripPayments(received: $received, notReceived: $notReceived)';
}


}

/// @nodoc
abstract mixin class _$TripPaymentsCopyWith<$Res> implements $TripPaymentsCopyWith<$Res> {
  factory _$TripPaymentsCopyWith(_TripPayments value, $Res Function(_TripPayments) _then) = __$TripPaymentsCopyWithImpl;
@override @useResult
$Res call({
 List<TripPaymentLine> received, List<TripPaymentLine> notReceived
});




}
/// @nodoc
class __$TripPaymentsCopyWithImpl<$Res>
    implements _$TripPaymentsCopyWith<$Res> {
  __$TripPaymentsCopyWithImpl(this._self, this._then);

  final _TripPayments _self;
  final $Res Function(_TripPayments) _then;

/// Create a copy of TripPayments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? received = null,Object? notReceived = null,}) {
  return _then(_TripPayments(
received: null == received ? _self._received : received // ignore: cast_nullable_to_non_nullable
as List<TripPaymentLine>,notReceived: null == notReceived ? _self._notReceived : notReceived // ignore: cast_nullable_to_non_nullable
as List<TripPaymentLine>,
  ));
}


}


/// @nodoc
mixin _$TripPaymentLine {

 String? get currency;@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? get method; double get amount; int get parcels;
/// Create a copy of TripPaymentLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripPaymentLineCopyWith<TripPaymentLine> get copyWith => _$TripPaymentLineCopyWithImpl<TripPaymentLine>(this as TripPaymentLine, _$identity);

  /// Serializes this TripPaymentLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripPaymentLine;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripPaymentLine&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.method, _this.method) || other.method == _this.method)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.parcels, _this.parcels) || other.parcels == _this.parcels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripPaymentLine;
  return Object.hash(runtimeType,_this.currency,_this.method,_this.amount,_this.parcels);
}

@override
String toString() {
  final _this = this as TripPaymentLine;
  return 'TripPaymentLine(currency: ${_this.currency}, method: ${_this.method}, amount: ${_this.amount}, parcels: ${_this.parcels})';
}


}

/// @nodoc
abstract mixin class $TripPaymentLineCopyWith<$Res>  {
  factory $TripPaymentLineCopyWith(TripPaymentLine value, $Res Function(TripPaymentLine) _then) = _$TripPaymentLineCopyWithImpl;
@useResult
$Res call({
 String? currency,@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? method, double amount, int parcels
});




}
/// @nodoc
class _$TripPaymentLineCopyWithImpl<$Res>
    implements $TripPaymentLineCopyWith<$Res> {
  _$TripPaymentLineCopyWithImpl(this._self, this._then);

  final TripPaymentLine _self;
  final $Res Function(TripPaymentLine) _then;

/// Create a copy of TripPaymentLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = freezed,Object? method = freezed,Object? amount = null,Object? parcels = null,}) {
  return _then(TripPaymentLine(
currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,parcels: null == parcels ? _self.parcels : parcels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TripPaymentLine].
extension TripPaymentLinePatterns on TripPaymentLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripPaymentLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripPaymentLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripPaymentLine value)  $default,){
final _that = this;
switch (_that) {
case _TripPaymentLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripPaymentLine value)?  $default,){
final _that = this;
switch (_that) {
case _TripPaymentLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? currency, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? method,  double amount,  int parcels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripPaymentLine() when $default != null:
return $default(_that.currency,_that.method,_that.amount,_that.parcels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? currency, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? method,  double amount,  int parcels)  $default,) {final _that = this;
switch (_that) {
case _TripPaymentLine():
return $default(_that.currency,_that.method,_that.amount,_that.parcels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? currency, @JsonKey(unknownEnumValue: PaymentMethod.unknown)  PaymentMethod? method,  double amount,  int parcels)?  $default,) {final _that = this;
switch (_that) {
case _TripPaymentLine() when $default != null:
return $default(_that.currency,_that.method,_that.amount,_that.parcels);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripPaymentLine implements TripPaymentLine {
  const _TripPaymentLine({this.currency, @JsonKey(unknownEnumValue: PaymentMethod.unknown) this.method, this.amount = 0, this.parcels = 0});
  factory _TripPaymentLine.fromJson(Map<String, dynamic> json) => _$TripPaymentLineFromJson(json);

@override final  String? currency;
@override@JsonKey(unknownEnumValue: PaymentMethod.unknown) final  PaymentMethod? method;
@override@JsonKey() final  double amount;
@override@JsonKey() final  int parcels;

/// Create a copy of TripPaymentLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripPaymentLineCopyWith<_TripPaymentLine> get copyWith => __$TripPaymentLineCopyWithImpl<_TripPaymentLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripPaymentLineToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripPaymentLine&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.parcels, parcels) || other.parcels == parcels));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,method,amount,parcels);
}

@override
String toString() {
    return 'TripPaymentLine(currency: $currency, method: $method, amount: $amount, parcels: $parcels)';
}


}

/// @nodoc
abstract mixin class _$TripPaymentLineCopyWith<$Res> implements $TripPaymentLineCopyWith<$Res> {
  factory _$TripPaymentLineCopyWith(_TripPaymentLine value, $Res Function(_TripPaymentLine) _then) = __$TripPaymentLineCopyWithImpl;
@override @useResult
$Res call({
 String? currency,@JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? method, double amount, int parcels
});




}
/// @nodoc
class __$TripPaymentLineCopyWithImpl<$Res>
    implements _$TripPaymentLineCopyWith<$Res> {
  __$TripPaymentLineCopyWithImpl(this._self, this._then);

  final _TripPaymentLine _self;
  final $Res Function(_TripPaymentLine) _then;

/// Create a copy of TripPaymentLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = freezed,Object? method = freezed,Object? amount = null,Object? parcels = null,}) {
  return _then(_TripPaymentLine(
currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,method: freezed == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as PaymentMethod?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,parcels: null == parcels ? _self.parcels : parcels // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TripHistoryEntry {

 int get id;@JsonKey(unknownEnumValue: TripEvent.unknown) TripEvent? get event;@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? get previousStatus;@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? get status; int? get parcelId; String? get parcelBarcode; int? get changedById; String? get changedByName; DateTime? get changedAt; String? get comment;
/// Create a copy of TripHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TripHistoryEntryCopyWith<TripHistoryEntry> get copyWith => _$TripHistoryEntryCopyWithImpl<TripHistoryEntry>(this as TripHistoryEntry, _$identity);

  /// Serializes this TripHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TripHistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TripHistoryEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.previousStatus, _this.previousStatus) || other.previousStatus == _this.previousStatus)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.parcelId, _this.parcelId) || other.parcelId == _this.parcelId)&&(identical(other.parcelBarcode, _this.parcelBarcode) || other.parcelBarcode == _this.parcelBarcode)&&(identical(other.changedById, _this.changedById) || other.changedById == _this.changedById)&&(identical(other.changedByName, _this.changedByName) || other.changedByName == _this.changedByName)&&(identical(other.changedAt, _this.changedAt) || other.changedAt == _this.changedAt)&&(identical(other.comment, _this.comment) || other.comment == _this.comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TripHistoryEntry;
  return Object.hash(runtimeType,_this.id,_this.event,_this.previousStatus,_this.status,_this.parcelId,_this.parcelBarcode,_this.changedById,_this.changedByName,_this.changedAt,_this.comment);
}

@override
String toString() {
  final _this = this as TripHistoryEntry;
  return 'TripHistoryEntry(id: ${_this.id}, event: ${_this.event}, previousStatus: ${_this.previousStatus}, status: ${_this.status}, parcelId: ${_this.parcelId}, parcelBarcode: ${_this.parcelBarcode}, changedById: ${_this.changedById}, changedByName: ${_this.changedByName}, changedAt: ${_this.changedAt}, comment: ${_this.comment})';
}


}

/// @nodoc
abstract mixin class $TripHistoryEntryCopyWith<$Res>  {
  factory $TripHistoryEntryCopyWith(TripHistoryEntry value, $Res Function(TripHistoryEntry) _then) = _$TripHistoryEntryCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: TripEvent.unknown) TripEvent? event,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? previousStatus,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? parcelId, String? parcelBarcode, int? changedById, String? changedByName, DateTime? changedAt, String? comment
});




}
/// @nodoc
class _$TripHistoryEntryCopyWithImpl<$Res>
    implements $TripHistoryEntryCopyWith<$Res> {
  _$TripHistoryEntryCopyWithImpl(this._self, this._then);

  final TripHistoryEntry _self;
  final $Res Function(TripHistoryEntry) _then;

/// Create a copy of TripHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? event = freezed,Object? previousStatus = freezed,Object? status = freezed,Object? parcelId = freezed,Object? parcelBarcode = freezed,Object? changedById = freezed,Object? changedByName = freezed,Object? changedAt = freezed,Object? comment = freezed,}) {
  return _then(TripHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as TripEvent?,previousStatus: freezed == previousStatus ? _self.previousStatus : previousStatus // ignore: cast_nullable_to_non_nullable
as TripStatus?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,parcelId: freezed == parcelId ? _self.parcelId : parcelId // ignore: cast_nullable_to_non_nullable
as int?,parcelBarcode: freezed == parcelBarcode ? _self.parcelBarcode : parcelBarcode // ignore: cast_nullable_to_non_nullable
as String?,changedById: freezed == changedById ? _self.changedById : changedById // ignore: cast_nullable_to_non_nullable
as int?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TripHistoryEntry].
extension TripHistoryEntryPatterns on TripHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TripHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TripHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TripHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _TripHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TripHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TripHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: TripEvent.unknown)  TripEvent? event, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? previousStatus, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? parcelId,  String? parcelBarcode,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TripHistoryEntry() when $default != null:
return $default(_that.id,_that.event,_that.previousStatus,_that.status,_that.parcelId,_that.parcelBarcode,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: TripEvent.unknown)  TripEvent? event, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? previousStatus, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? parcelId,  String? parcelBarcode,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _TripHistoryEntry():
return $default(_that.id,_that.event,_that.previousStatus,_that.status,_that.parcelId,_that.parcelBarcode,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(unknownEnumValue: TripEvent.unknown)  TripEvent? event, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? previousStatus, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? parcelId,  String? parcelBarcode,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _TripHistoryEntry() when $default != null:
return $default(_that.id,_that.event,_that.previousStatus,_that.status,_that.parcelId,_that.parcelBarcode,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TripHistoryEntry implements TripHistoryEntry {
  const _TripHistoryEntry({required this.id, @JsonKey(unknownEnumValue: TripEvent.unknown) this.event, @JsonKey(unknownEnumValue: TripStatus.unknown) this.previousStatus, @JsonKey(unknownEnumValue: TripStatus.unknown) this.status, this.parcelId, this.parcelBarcode, this.changedById, this.changedByName, this.changedAt, this.comment});
  factory _TripHistoryEntry.fromJson(Map<String, dynamic> json) => _$TripHistoryEntryFromJson(json);

@override final  int id;
@override@JsonKey(unknownEnumValue: TripEvent.unknown) final  TripEvent? event;
@override@JsonKey(unknownEnumValue: TripStatus.unknown) final  TripStatus? previousStatus;
@override@JsonKey(unknownEnumValue: TripStatus.unknown) final  TripStatus? status;
@override final  int? parcelId;
@override final  String? parcelBarcode;
@override final  int? changedById;
@override final  String? changedByName;
@override final  DateTime? changedAt;
@override final  String? comment;

/// Create a copy of TripHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TripHistoryEntryCopyWith<_TripHistoryEntry> get copyWith => __$TripHistoryEntryCopyWithImpl<_TripHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TripHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TripHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.event, event) || other.event == event)&&(identical(other.previousStatus, previousStatus) || other.previousStatus == previousStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.parcelId, parcelId) || other.parcelId == parcelId)&&(identical(other.parcelBarcode, parcelBarcode) || other.parcelBarcode == parcelBarcode)&&(identical(other.changedById, changedById) || other.changedById == changedById)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,event,previousStatus,status,parcelId,parcelBarcode,changedById,changedByName,changedAt,comment);
}

@override
String toString() {
    return 'TripHistoryEntry(id: $id, event: $event, previousStatus: $previousStatus, status: $status, parcelId: $parcelId, parcelBarcode: $parcelBarcode, changedById: $changedById, changedByName: $changedByName, changedAt: $changedAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$TripHistoryEntryCopyWith<$Res> implements $TripHistoryEntryCopyWith<$Res> {
  factory _$TripHistoryEntryCopyWith(_TripHistoryEntry value, $Res Function(_TripHistoryEntry) _then) = __$TripHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: TripEvent.unknown) TripEvent? event,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? previousStatus,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? parcelId, String? parcelBarcode, int? changedById, String? changedByName, DateTime? changedAt, String? comment
});




}
/// @nodoc
class __$TripHistoryEntryCopyWithImpl<$Res>
    implements _$TripHistoryEntryCopyWith<$Res> {
  __$TripHistoryEntryCopyWithImpl(this._self, this._then);

  final _TripHistoryEntry _self;
  final $Res Function(_TripHistoryEntry) _then;

/// Create a copy of TripHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? event = freezed,Object? previousStatus = freezed,Object? status = freezed,Object? parcelId = freezed,Object? parcelBarcode = freezed,Object? changedById = freezed,Object? changedByName = freezed,Object? changedAt = freezed,Object? comment = freezed,}) {
  return _then(_TripHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,event: freezed == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as TripEvent?,previousStatus: freezed == previousStatus ? _self.previousStatus : previousStatus // ignore: cast_nullable_to_non_nullable
as TripStatus?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,parcelId: freezed == parcelId ? _self.parcelId : parcelId // ignore: cast_nullable_to_non_nullable
as int?,parcelBarcode: freezed == parcelBarcode ? _self.parcelBarcode : parcelBarcode // ignore: cast_nullable_to_non_nullable
as String?,changedById: freezed == changedById ? _self.changedById : changedById // ignore: cast_nullable_to_non_nullable
as int?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
