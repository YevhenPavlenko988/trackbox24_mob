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

 int get id;@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? get status; int? get carId; String? get carPlateNumber; int? get driverId; String? get driverName; DateTime? get plannedDepartureAt; DateTime? get plannedArrivalAt; String? get origin; String? get destination; String? get notes; DateTime? get departedAt; DateTime? get arrivedAt; int? get startOdometerKm; int? get endOdometerKm;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trip&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.carId, _this.carId) || other.carId == _this.carId)&&(identical(other.carPlateNumber, _this.carPlateNumber) || other.carPlateNumber == _this.carPlateNumber)&&(identical(other.driverId, _this.driverId) || other.driverId == _this.driverId)&&(identical(other.driverName, _this.driverName) || other.driverName == _this.driverName)&&(identical(other.plannedDepartureAt, _this.plannedDepartureAt) || other.plannedDepartureAt == _this.plannedDepartureAt)&&(identical(other.plannedArrivalAt, _this.plannedArrivalAt) || other.plannedArrivalAt == _this.plannedArrivalAt)&&(identical(other.origin, _this.origin) || other.origin == _this.origin)&&(identical(other.destination, _this.destination) || other.destination == _this.destination)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.departedAt, _this.departedAt) || other.departedAt == _this.departedAt)&&(identical(other.arrivedAt, _this.arrivedAt) || other.arrivedAt == _this.arrivedAt)&&(identical(other.startOdometerKm, _this.startOdometerKm) || other.startOdometerKm == _this.startOdometerKm)&&(identical(other.endOdometerKm, _this.endOdometerKm) || other.endOdometerKm == _this.endOdometerKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Trip;
  return Object.hash(runtimeType,_this.id,_this.status,_this.carId,_this.carPlateNumber,_this.driverId,_this.driverName,_this.plannedDepartureAt,_this.plannedArrivalAt,_this.origin,_this.destination,_this.notes,_this.departedAt,_this.arrivedAt,_this.startOdometerKm,_this.endOdometerKm);
}

@override
String toString() {
  final _this = this as Trip;
  return 'Trip(id: ${_this.id}, status: ${_this.status}, carId: ${_this.carId}, carPlateNumber: ${_this.carPlateNumber}, driverId: ${_this.driverId}, driverName: ${_this.driverName}, plannedDepartureAt: ${_this.plannedDepartureAt}, plannedArrivalAt: ${_this.plannedArrivalAt}, origin: ${_this.origin}, destination: ${_this.destination}, notes: ${_this.notes}, departedAt: ${_this.departedAt}, arrivedAt: ${_this.arrivedAt}, startOdometerKm: ${_this.startOdometerKm}, endOdometerKm: ${_this.endOdometerKm})';
}


}

/// @nodoc
abstract mixin class $TripCopyWith<$Res>  {
  factory $TripCopyWith(Trip value, $Res Function(Trip) _then) = _$TripCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? carId, String? carPlateNumber, int? driverId, String? driverName, DateTime? plannedDepartureAt, DateTime? plannedArrivalAt, String? origin, String? destination, String? notes, DateTime? departedAt, DateTime? arrivedAt, int? startOdometerKm, int? endOdometerKm
});




}
/// @nodoc
class _$TripCopyWithImpl<$Res>
    implements $TripCopyWith<$Res> {
  _$TripCopyWithImpl(this._self, this._then);

  final Trip _self;
  final $Res Function(Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = freezed,Object? carId = freezed,Object? carPlateNumber = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? plannedDepartureAt = freezed,Object? plannedArrivalAt = freezed,Object? origin = freezed,Object? destination = freezed,Object? notes = freezed,Object? departedAt = freezed,Object? arrivedAt = freezed,Object? startOdometerKm = freezed,Object? endOdometerKm = freezed,}) {
  return _then(Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,carId: freezed == carId ? _self.carId : carId // ignore: cast_nullable_to_non_nullable
as int?,carPlateNumber: freezed == carPlateNumber ? _self.carPlateNumber : carPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,plannedDepartureAt: freezed == plannedDepartureAt ? _self.plannedDepartureAt : plannedDepartureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedArrivalAt: freezed == plannedArrivalAt ? _self.plannedArrivalAt : plannedArrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,departedAt: freezed == departedAt ? _self.departedAt : departedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startOdometerKm: freezed == startOdometerKm ? _self.startOdometerKm : startOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,endOdometerKm: freezed == endOdometerKm ? _self.endOdometerKm : endOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm)  $default,) {final _that = this;
switch (_that) {
case _Trip():
return $default(_that.id,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(unknownEnumValue: TripStatus.unknown)  TripStatus? status,  int? carId,  String? carPlateNumber,  int? driverId,  String? driverName,  DateTime? plannedDepartureAt,  DateTime? plannedArrivalAt,  String? origin,  String? destination,  String? notes,  DateTime? departedAt,  DateTime? arrivedAt,  int? startOdometerKm,  int? endOdometerKm)?  $default,) {final _that = this;
switch (_that) {
case _Trip() when $default != null:
return $default(_that.id,_that.status,_that.carId,_that.carPlateNumber,_that.driverId,_that.driverName,_that.plannedDepartureAt,_that.plannedArrivalAt,_that.origin,_that.destination,_that.notes,_that.departedAt,_that.arrivedAt,_that.startOdometerKm,_that.endOdometerKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trip extends Trip {
  const _Trip({required this.id, @JsonKey(unknownEnumValue: TripStatus.unknown) this.status, this.carId, this.carPlateNumber, this.driverId, this.driverName, this.plannedDepartureAt, this.plannedArrivalAt, this.origin, this.destination, this.notes, this.departedAt, this.arrivedAt, this.startOdometerKm, this.endOdometerKm}): super._();
  factory _Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

@override final  int id;
@override@JsonKey(unknownEnumValue: TripStatus.unknown) final  TripStatus? status;
@override final  int? carId;
@override final  String? carPlateNumber;
@override final  int? driverId;
@override final  String? driverName;
@override final  DateTime? plannedDepartureAt;
@override final  DateTime? plannedArrivalAt;
@override final  String? origin;
@override final  String? destination;
@override final  String? notes;
@override final  DateTime? departedAt;
@override final  DateTime? arrivedAt;
@override final  int? startOdometerKm;
@override final  int? endOdometerKm;

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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trip&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.carId, carId) || other.carId == carId)&&(identical(other.carPlateNumber, carPlateNumber) || other.carPlateNumber == carPlateNumber)&&(identical(other.driverId, driverId) || other.driverId == driverId)&&(identical(other.driverName, driverName) || other.driverName == driverName)&&(identical(other.plannedDepartureAt, plannedDepartureAt) || other.plannedDepartureAt == plannedDepartureAt)&&(identical(other.plannedArrivalAt, plannedArrivalAt) || other.plannedArrivalAt == plannedArrivalAt)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.departedAt, departedAt) || other.departedAt == departedAt)&&(identical(other.arrivedAt, arrivedAt) || other.arrivedAt == arrivedAt)&&(identical(other.startOdometerKm, startOdometerKm) || other.startOdometerKm == startOdometerKm)&&(identical(other.endOdometerKm, endOdometerKm) || other.endOdometerKm == endOdometerKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,carId,carPlateNumber,driverId,driverName,plannedDepartureAt,plannedArrivalAt,origin,destination,notes,departedAt,arrivedAt,startOdometerKm,endOdometerKm);
}

@override
String toString() {
    return 'Trip(id: $id, status: $status, carId: $carId, carPlateNumber: $carPlateNumber, driverId: $driverId, driverName: $driverName, plannedDepartureAt: $plannedDepartureAt, plannedArrivalAt: $plannedArrivalAt, origin: $origin, destination: $destination, notes: $notes, departedAt: $departedAt, arrivedAt: $arrivedAt, startOdometerKm: $startOdometerKm, endOdometerKm: $endOdometerKm)';
}


}

/// @nodoc
abstract mixin class _$TripCopyWith<$Res> implements $TripCopyWith<$Res> {
  factory _$TripCopyWith(_Trip value, $Res Function(_Trip) _then) = __$TripCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status, int? carId, String? carPlateNumber, int? driverId, String? driverName, DateTime? plannedDepartureAt, DateTime? plannedArrivalAt, String? origin, String? destination, String? notes, DateTime? departedAt, DateTime? arrivedAt, int? startOdometerKm, int? endOdometerKm
});




}
/// @nodoc
class __$TripCopyWithImpl<$Res>
    implements _$TripCopyWith<$Res> {
  __$TripCopyWithImpl(this._self, this._then);

  final _Trip _self;
  final $Res Function(_Trip) _then;

/// Create a copy of Trip
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = freezed,Object? carId = freezed,Object? carPlateNumber = freezed,Object? driverId = freezed,Object? driverName = freezed,Object? plannedDepartureAt = freezed,Object? plannedArrivalAt = freezed,Object? origin = freezed,Object? destination = freezed,Object? notes = freezed,Object? departedAt = freezed,Object? arrivedAt = freezed,Object? startOdometerKm = freezed,Object? endOdometerKm = freezed,}) {
  return _then(_Trip(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TripStatus?,carId: freezed == carId ? _self.carId : carId // ignore: cast_nullable_to_non_nullable
as int?,carPlateNumber: freezed == carPlateNumber ? _self.carPlateNumber : carPlateNumber // ignore: cast_nullable_to_non_nullable
as String?,driverId: freezed == driverId ? _self.driverId : driverId // ignore: cast_nullable_to_non_nullable
as int?,driverName: freezed == driverName ? _self.driverName : driverName // ignore: cast_nullable_to_non_nullable
as String?,plannedDepartureAt: freezed == plannedDepartureAt ? _self.plannedDepartureAt : plannedDepartureAt // ignore: cast_nullable_to_non_nullable
as DateTime?,plannedArrivalAt: freezed == plannedArrivalAt ? _self.plannedArrivalAt : plannedArrivalAt // ignore: cast_nullable_to_non_nullable
as DateTime?,origin: freezed == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String?,destination: freezed == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,departedAt: freezed == departedAt ? _self.departedAt : departedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,arrivedAt: freezed == arrivedAt ? _self.arrivedAt : arrivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,startOdometerKm: freezed == startOdometerKm ? _self.startOdometerKm : startOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,endOdometerKm: freezed == endOdometerKm ? _self.endOdometerKm : endOdometerKm // ignore: cast_nullable_to_non_nullable
as int?,
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
