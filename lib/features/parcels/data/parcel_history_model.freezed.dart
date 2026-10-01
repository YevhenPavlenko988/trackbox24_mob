// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_history_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParcelHistoryEntry {

 int get id; int? get seatNumber;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get previousStatus;@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? get status; int? get warehouseId; String? get warehouseName; String? get npStatusCode; String? get npStatusText;@JsonKey(unknownEnumValue: HistorySource.unknown) HistorySource? get source; int? get changedById; String? get changedByName; DateTime? get changedAt; String? get comment;
/// Create a copy of ParcelHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelHistoryEntryCopyWith<ParcelHistoryEntry> get copyWith => _$ParcelHistoryEntryCopyWithImpl<ParcelHistoryEntry>(this as ParcelHistoryEntry, _$identity);

  /// Serializes this ParcelHistoryEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParcelHistoryEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParcelHistoryEntry&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.seatNumber, _this.seatNumber) || other.seatNumber == _this.seatNumber)&&(identical(other.previousStatus, _this.previousStatus) || other.previousStatus == _this.previousStatus)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.warehouseId, _this.warehouseId) || other.warehouseId == _this.warehouseId)&&(identical(other.warehouseName, _this.warehouseName) || other.warehouseName == _this.warehouseName)&&(identical(other.npStatusCode, _this.npStatusCode) || other.npStatusCode == _this.npStatusCode)&&(identical(other.npStatusText, _this.npStatusText) || other.npStatusText == _this.npStatusText)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.changedById, _this.changedById) || other.changedById == _this.changedById)&&(identical(other.changedByName, _this.changedByName) || other.changedByName == _this.changedByName)&&(identical(other.changedAt, _this.changedAt) || other.changedAt == _this.changedAt)&&(identical(other.comment, _this.comment) || other.comment == _this.comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParcelHistoryEntry;
  return Object.hash(runtimeType,_this.id,_this.seatNumber,_this.previousStatus,_this.status,_this.warehouseId,_this.warehouseName,_this.npStatusCode,_this.npStatusText,_this.source,_this.changedById,_this.changedByName,_this.changedAt,_this.comment);
}

@override
String toString() {
  final _this = this as ParcelHistoryEntry;
  return 'ParcelHistoryEntry(id: ${_this.id}, seatNumber: ${_this.seatNumber}, previousStatus: ${_this.previousStatus}, status: ${_this.status}, warehouseId: ${_this.warehouseId}, warehouseName: ${_this.warehouseName}, npStatusCode: ${_this.npStatusCode}, npStatusText: ${_this.npStatusText}, source: ${_this.source}, changedById: ${_this.changedById}, changedByName: ${_this.changedByName}, changedAt: ${_this.changedAt}, comment: ${_this.comment})';
}


}

/// @nodoc
abstract mixin class $ParcelHistoryEntryCopyWith<$Res>  {
  factory $ParcelHistoryEntryCopyWith(ParcelHistoryEntry value, $Res Function(ParcelHistoryEntry) _then) = _$ParcelHistoryEntryCopyWithImpl;
@useResult
$Res call({
 int id, int? seatNumber,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? previousStatus,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, int? warehouseId, String? warehouseName, String? npStatusCode, String? npStatusText,@JsonKey(unknownEnumValue: HistorySource.unknown) HistorySource? source, int? changedById, String? changedByName, DateTime? changedAt, String? comment
});




}
/// @nodoc
class _$ParcelHistoryEntryCopyWithImpl<$Res>
    implements $ParcelHistoryEntryCopyWith<$Res> {
  _$ParcelHistoryEntryCopyWithImpl(this._self, this._then);

  final ParcelHistoryEntry _self;
  final $Res Function(ParcelHistoryEntry) _then;

/// Create a copy of ParcelHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seatNumber = freezed,Object? previousStatus = freezed,Object? status = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? npStatusCode = freezed,Object? npStatusText = freezed,Object? source = freezed,Object? changedById = freezed,Object? changedByName = freezed,Object? changedAt = freezed,Object? comment = freezed,}) {
  return _then(ParcelHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seatNumber: freezed == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int?,previousStatus: freezed == previousStatus ? _self.previousStatus : previousStatus // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HistorySource?,changedById: freezed == changedById ? _self.changedById : changedById // ignore: cast_nullable_to_non_nullable
as int?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParcelHistoryEntry].
extension ParcelHistoryEntryPatterns on ParcelHistoryEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParcelHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParcelHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParcelHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _ParcelHistoryEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParcelHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ParcelHistoryEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? seatNumber, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? previousStatus, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  int? warehouseId,  String? warehouseName,  String? npStatusCode,  String? npStatusText, @JsonKey(unknownEnumValue: HistorySource.unknown)  HistorySource? source,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParcelHistoryEntry() when $default != null:
return $default(_that.id,_that.seatNumber,_that.previousStatus,_that.status,_that.warehouseId,_that.warehouseName,_that.npStatusCode,_that.npStatusText,_that.source,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? seatNumber, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? previousStatus, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  int? warehouseId,  String? warehouseName,  String? npStatusCode,  String? npStatusText, @JsonKey(unknownEnumValue: HistorySource.unknown)  HistorySource? source,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)  $default,) {final _that = this;
switch (_that) {
case _ParcelHistoryEntry():
return $default(_that.id,_that.seatNumber,_that.previousStatus,_that.status,_that.warehouseId,_that.warehouseName,_that.npStatusCode,_that.npStatusText,_that.source,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? seatNumber, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? previousStatus, @JsonKey(unknownEnumValue: ParcelStatus.unknown)  ParcelStatus? status,  int? warehouseId,  String? warehouseName,  String? npStatusCode,  String? npStatusText, @JsonKey(unknownEnumValue: HistorySource.unknown)  HistorySource? source,  int? changedById,  String? changedByName,  DateTime? changedAt,  String? comment)?  $default,) {final _that = this;
switch (_that) {
case _ParcelHistoryEntry() when $default != null:
return $default(_that.id,_that.seatNumber,_that.previousStatus,_that.status,_that.warehouseId,_that.warehouseName,_that.npStatusCode,_that.npStatusText,_that.source,_that.changedById,_that.changedByName,_that.changedAt,_that.comment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParcelHistoryEntry implements ParcelHistoryEntry {
  const _ParcelHistoryEntry({required this.id, this.seatNumber, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.previousStatus, @JsonKey(unknownEnumValue: ParcelStatus.unknown) this.status, this.warehouseId, this.warehouseName, this.npStatusCode, this.npStatusText, @JsonKey(unknownEnumValue: HistorySource.unknown) this.source, this.changedById, this.changedByName, this.changedAt, this.comment});
  factory _ParcelHistoryEntry.fromJson(Map<String, dynamic> json) => _$ParcelHistoryEntryFromJson(json);

@override final  int id;
@override final  int? seatNumber;
@override@JsonKey(unknownEnumValue: ParcelStatus.unknown) final  ParcelStatus? previousStatus;
@override@JsonKey(unknownEnumValue: ParcelStatus.unknown) final  ParcelStatus? status;
@override final  int? warehouseId;
@override final  String? warehouseName;
@override final  String? npStatusCode;
@override final  String? npStatusText;
@override@JsonKey(unknownEnumValue: HistorySource.unknown) final  HistorySource? source;
@override final  int? changedById;
@override final  String? changedByName;
@override final  DateTime? changedAt;
@override final  String? comment;

/// Create a copy of ParcelHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelHistoryEntryCopyWith<_ParcelHistoryEntry> get copyWith => __$ParcelHistoryEntryCopyWithImpl<_ParcelHistoryEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParcelHistoryEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParcelHistoryEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.seatNumber, seatNumber) || other.seatNumber == seatNumber)&&(identical(other.previousStatus, previousStatus) || other.previousStatus == previousStatus)&&(identical(other.status, status) || other.status == status)&&(identical(other.warehouseId, warehouseId) || other.warehouseId == warehouseId)&&(identical(other.warehouseName, warehouseName) || other.warehouseName == warehouseName)&&(identical(other.npStatusCode, npStatusCode) || other.npStatusCode == npStatusCode)&&(identical(other.npStatusText, npStatusText) || other.npStatusText == npStatusText)&&(identical(other.source, source) || other.source == source)&&(identical(other.changedById, changedById) || other.changedById == changedById)&&(identical(other.changedByName, changedByName) || other.changedByName == changedByName)&&(identical(other.changedAt, changedAt) || other.changedAt == changedAt)&&(identical(other.comment, comment) || other.comment == comment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,seatNumber,previousStatus,status,warehouseId,warehouseName,npStatusCode,npStatusText,source,changedById,changedByName,changedAt,comment);
}

@override
String toString() {
    return 'ParcelHistoryEntry(id: $id, seatNumber: $seatNumber, previousStatus: $previousStatus, status: $status, warehouseId: $warehouseId, warehouseName: $warehouseName, npStatusCode: $npStatusCode, npStatusText: $npStatusText, source: $source, changedById: $changedById, changedByName: $changedByName, changedAt: $changedAt, comment: $comment)';
}


}

/// @nodoc
abstract mixin class _$ParcelHistoryEntryCopyWith<$Res> implements $ParcelHistoryEntryCopyWith<$Res> {
  factory _$ParcelHistoryEntryCopyWith(_ParcelHistoryEntry value, $Res Function(_ParcelHistoryEntry) _then) = __$ParcelHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, int? seatNumber,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? previousStatus,@JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status, int? warehouseId, String? warehouseName, String? npStatusCode, String? npStatusText,@JsonKey(unknownEnumValue: HistorySource.unknown) HistorySource? source, int? changedById, String? changedByName, DateTime? changedAt, String? comment
});




}
/// @nodoc
class __$ParcelHistoryEntryCopyWithImpl<$Res>
    implements _$ParcelHistoryEntryCopyWith<$Res> {
  __$ParcelHistoryEntryCopyWithImpl(this._self, this._then);

  final _ParcelHistoryEntry _self;
  final $Res Function(_ParcelHistoryEntry) _then;

/// Create a copy of ParcelHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seatNumber = freezed,Object? previousStatus = freezed,Object? status = freezed,Object? warehouseId = freezed,Object? warehouseName = freezed,Object? npStatusCode = freezed,Object? npStatusText = freezed,Object? source = freezed,Object? changedById = freezed,Object? changedByName = freezed,Object? changedAt = freezed,Object? comment = freezed,}) {
  return _then(_ParcelHistoryEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,seatNumber: freezed == seatNumber ? _self.seatNumber : seatNumber // ignore: cast_nullable_to_non_nullable
as int?,previousStatus: freezed == previousStatus ? _self.previousStatus : previousStatus // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,warehouseId: freezed == warehouseId ? _self.warehouseId : warehouseId // ignore: cast_nullable_to_non_nullable
as int?,warehouseName: freezed == warehouseName ? _self.warehouseName : warehouseName // ignore: cast_nullable_to_non_nullable
as String?,npStatusCode: freezed == npStatusCode ? _self.npStatusCode : npStatusCode // ignore: cast_nullable_to_non_nullable
as String?,npStatusText: freezed == npStatusText ? _self.npStatusText : npStatusText // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as HistorySource?,changedById: freezed == changedById ? _self.changedById : changedById // ignore: cast_nullable_to_non_nullable
as int?,changedByName: freezed == changedByName ? _self.changedByName : changedByName // ignore: cast_nullable_to_non_nullable
as String?,changedAt: freezed == changedAt ? _self.changedAt : changedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
