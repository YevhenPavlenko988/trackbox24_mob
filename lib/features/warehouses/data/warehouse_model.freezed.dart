// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'warehouse_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Warehouse {

 int get id; String get name; String? get address; String? get notes; bool get active;
/// Create a copy of Warehouse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WarehouseCopyWith<Warehouse> get copyWith => _$WarehouseCopyWithImpl<Warehouse>(this as Warehouse, _$identity);

  /// Serializes this Warehouse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Warehouse;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Warehouse&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.active, _this.active) || other.active == _this.active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Warehouse;
  return Object.hash(runtimeType,_this.id,_this.name,_this.address,_this.notes,_this.active);
}

@override
String toString() {
  final _this = this as Warehouse;
  return 'Warehouse(id: ${_this.id}, name: ${_this.name}, address: ${_this.address}, notes: ${_this.notes}, active: ${_this.active})';
}


}

/// @nodoc
abstract mixin class $WarehouseCopyWith<$Res>  {
  factory $WarehouseCopyWith(Warehouse value, $Res Function(Warehouse) _then) = _$WarehouseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? address, String? notes, bool active
});




}
/// @nodoc
class _$WarehouseCopyWithImpl<$Res>
    implements $WarehouseCopyWith<$Res> {
  _$WarehouseCopyWithImpl(this._self, this._then);

  final Warehouse _self;
  final $Res Function(Warehouse) _then;

/// Create a copy of Warehouse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? notes = freezed,Object? active = null,}) {
  return _then(Warehouse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Warehouse].
extension WarehousePatterns on Warehouse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Warehouse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Warehouse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Warehouse value)  $default,){
final _that = this;
switch (_that) {
case _Warehouse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Warehouse value)?  $default,){
final _that = this;
switch (_that) {
case _Warehouse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? address,  String? notes,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Warehouse() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.notes,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? address,  String? notes,  bool active)  $default,) {final _that = this;
switch (_that) {
case _Warehouse():
return $default(_that.id,_that.name,_that.address,_that.notes,_that.active);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? address,  String? notes,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _Warehouse() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.notes,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Warehouse implements Warehouse {
  const _Warehouse({required this.id, required this.name, this.address, this.notes, this.active = true});
  factory _Warehouse.fromJson(Map<String, dynamic> json) => _$WarehouseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? address;
@override final  String? notes;
@override@JsonKey() final  bool active;

/// Create a copy of Warehouse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WarehouseCopyWith<_Warehouse> get copyWith => __$WarehouseCopyWithImpl<_Warehouse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WarehouseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Warehouse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,address,notes,active);
}

@override
String toString() {
    return 'Warehouse(id: $id, name: $name, address: $address, notes: $notes, active: $active)';
}


}

/// @nodoc
abstract mixin class _$WarehouseCopyWith<$Res> implements $WarehouseCopyWith<$Res> {
  factory _$WarehouseCopyWith(_Warehouse value, $Res Function(_Warehouse) _then) = __$WarehouseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? address, String? notes, bool active
});




}
/// @nodoc
class __$WarehouseCopyWithImpl<$Res>
    implements _$WarehouseCopyWith<$Res> {
  __$WarehouseCopyWithImpl(this._self, this._then);

  final _Warehouse _self;
  final $Res Function(_Warehouse) _then;

/// Create a copy of Warehouse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? notes = freezed,Object? active = null,}) {
  return _then(_Warehouse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
