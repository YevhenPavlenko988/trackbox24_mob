// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'np_directory_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NpRef {

 String? get ref; String? get name;
/// Create a copy of NpRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpRefCopyWith<NpRef> get copyWith => _$NpRefCopyWithImpl<NpRef>(this as NpRef, _$identity);

  /// Serializes this NpRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpRef&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.name, _this.name) || other.name == _this.name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpRef;
  return Object.hash(runtimeType,_this.ref,_this.name);
}

@override
String toString() {
  final _this = this as NpRef;
  return 'NpRef(ref: ${_this.ref}, name: ${_this.name})';
}


}

/// @nodoc
abstract mixin class $NpRefCopyWith<$Res>  {
  factory $NpRefCopyWith(NpRef value, $Res Function(NpRef) _then) = _$NpRefCopyWithImpl;
@useResult
$Res call({
 String? ref, String? name
});




}
/// @nodoc
class _$NpRefCopyWithImpl<$Res>
    implements $NpRefCopyWith<$Res> {
  _$NpRefCopyWithImpl(this._self, this._then);

  final NpRef _self;
  final $Res Function(NpRef) _then;

/// Create a copy of NpRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = freezed,Object? name = freezed,}) {
  return _then(NpRef(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NpRef].
extension NpRefPatterns on NpRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpRef value)  $default,){
final _that = this;
switch (_that) {
case _NpRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpRef value)?  $default,){
final _that = this;
switch (_that) {
case _NpRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ref,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpRef() when $default != null:
return $default(_that.ref,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ref,  String? name)  $default,) {final _that = this;
switch (_that) {
case _NpRef():
return $default(_that.ref,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ref,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _NpRef() when $default != null:
return $default(_that.ref,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpRef implements NpRef {
  const _NpRef({this.ref, this.name});
  factory _NpRef.fromJson(Map<String, dynamic> json) => _$NpRefFromJson(json);

@override final  String? ref;
@override final  String? name;

/// Create a copy of NpRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpRefCopyWith<_NpRef> get copyWith => __$NpRefCopyWithImpl<_NpRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpRef&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,name);
}

@override
String toString() {
    return 'NpRef(ref: $ref, name: $name)';
}


}

/// @nodoc
abstract mixin class _$NpRefCopyWith<$Res> implements $NpRefCopyWith<$Res> {
  factory _$NpRefCopyWith(_NpRef value, $Res Function(_NpRef) _then) = __$NpRefCopyWithImpl;
@override @useResult
$Res call({
 String? ref, String? name
});




}
/// @nodoc
class __$NpRefCopyWithImpl<$Res>
    implements _$NpRefCopyWith<$Res> {
  __$NpRefCopyWithImpl(this._self, this._then);

  final _NpRef _self;
  final $Res Function(_NpRef) _then;

/// Create a copy of NpRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = freezed,Object? name = freezed,}) {
  return _then(_NpRef(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NpCity {

 String? get ref; String? get name; String? get area;
/// Create a copy of NpCity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpCityCopyWith<NpCity> get copyWith => _$NpCityCopyWithImpl<NpCity>(this as NpCity, _$identity);

  /// Serializes this NpCity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpCity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpCity&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.area, _this.area) || other.area == _this.area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpCity;
  return Object.hash(runtimeType,_this.ref,_this.name,_this.area);
}

@override
String toString() {
  final _this = this as NpCity;
  return 'NpCity(ref: ${_this.ref}, name: ${_this.name}, area: ${_this.area})';
}


}

/// @nodoc
abstract mixin class $NpCityCopyWith<$Res>  {
  factory $NpCityCopyWith(NpCity value, $Res Function(NpCity) _then) = _$NpCityCopyWithImpl;
@useResult
$Res call({
 String? ref, String? name, String? area
});




}
/// @nodoc
class _$NpCityCopyWithImpl<$Res>
    implements $NpCityCopyWith<$Res> {
  _$NpCityCopyWithImpl(this._self, this._then);

  final NpCity _self;
  final $Res Function(NpCity) _then;

/// Create a copy of NpCity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = freezed,Object? name = freezed,Object? area = freezed,}) {
  return _then(NpCity(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NpCity].
extension NpCityPatterns on NpCity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpCity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpCity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpCity value)  $default,){
final _that = this;
switch (_that) {
case _NpCity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpCity value)?  $default,){
final _that = this;
switch (_that) {
case _NpCity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? area)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpCity() when $default != null:
return $default(_that.ref,_that.name,_that.area);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? area)  $default,) {final _that = this;
switch (_that) {
case _NpCity():
return $default(_that.ref,_that.name,_that.area);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ref,  String? name,  String? area)?  $default,) {final _that = this;
switch (_that) {
case _NpCity() when $default != null:
return $default(_that.ref,_that.name,_that.area);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpCity implements NpCity {
  const _NpCity({this.ref, this.name, this.area});
  factory _NpCity.fromJson(Map<String, dynamic> json) => _$NpCityFromJson(json);

@override final  String? ref;
@override final  String? name;
@override final  String? area;

/// Create a copy of NpCity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpCityCopyWith<_NpCity> get copyWith => __$NpCityCopyWithImpl<_NpCity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpCityToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpCity&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.name, name) || other.name == name)&&(identical(other.area, area) || other.area == area));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,name,area);
}

@override
String toString() {
    return 'NpCity(ref: $ref, name: $name, area: $area)';
}


}

/// @nodoc
abstract mixin class _$NpCityCopyWith<$Res> implements $NpCityCopyWith<$Res> {
  factory _$NpCityCopyWith(_NpCity value, $Res Function(_NpCity) _then) = __$NpCityCopyWithImpl;
@override @useResult
$Res call({
 String? ref, String? name, String? area
});




}
/// @nodoc
class __$NpCityCopyWithImpl<$Res>
    implements _$NpCityCopyWith<$Res> {
  __$NpCityCopyWithImpl(this._self, this._then);

  final _NpCity _self;
  final $Res Function(_NpCity) _then;

/// Create a copy of NpCity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = freezed,Object? name = freezed,Object? area = freezed,}) {
  return _then(_NpCity(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,area: freezed == area ? _self.area : area // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NpBranch {

 String? get ref; String? get name; String? get number; bool get postomat;
/// Create a copy of NpBranch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpBranchCopyWith<NpBranch> get copyWith => _$NpBranchCopyWithImpl<NpBranch>(this as NpBranch, _$identity);

  /// Serializes this NpBranch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpBranch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpBranch&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.postomat, _this.postomat) || other.postomat == _this.postomat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpBranch;
  return Object.hash(runtimeType,_this.ref,_this.name,_this.number,_this.postomat);
}

@override
String toString() {
  final _this = this as NpBranch;
  return 'NpBranch(ref: ${_this.ref}, name: ${_this.name}, number: ${_this.number}, postomat: ${_this.postomat})';
}


}

/// @nodoc
abstract mixin class $NpBranchCopyWith<$Res>  {
  factory $NpBranchCopyWith(NpBranch value, $Res Function(NpBranch) _then) = _$NpBranchCopyWithImpl;
@useResult
$Res call({
 String? ref, String? name, String? number, bool postomat
});




}
/// @nodoc
class _$NpBranchCopyWithImpl<$Res>
    implements $NpBranchCopyWith<$Res> {
  _$NpBranchCopyWithImpl(this._self, this._then);

  final NpBranch _self;
  final $Res Function(NpBranch) _then;

/// Create a copy of NpBranch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = freezed,Object? name = freezed,Object? number = freezed,Object? postomat = null,}) {
  return _then(NpBranch(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,postomat: null == postomat ? _self.postomat : postomat // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NpBranch].
extension NpBranchPatterns on NpBranch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpBranch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpBranch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpBranch value)  $default,){
final _that = this;
switch (_that) {
case _NpBranch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpBranch value)?  $default,){
final _that = this;
switch (_that) {
case _NpBranch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? number,  bool postomat)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpBranch() when $default != null:
return $default(_that.ref,_that.name,_that.number,_that.postomat);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? number,  bool postomat)  $default,) {final _that = this;
switch (_that) {
case _NpBranch():
return $default(_that.ref,_that.name,_that.number,_that.postomat);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ref,  String? name,  String? number,  bool postomat)?  $default,) {final _that = this;
switch (_that) {
case _NpBranch() when $default != null:
return $default(_that.ref,_that.name,_that.number,_that.postomat);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpBranch implements NpBranch {
  const _NpBranch({this.ref, this.name, this.number, this.postomat = false});
  factory _NpBranch.fromJson(Map<String, dynamic> json) => _$NpBranchFromJson(json);

@override final  String? ref;
@override final  String? name;
@override final  String? number;
@override@JsonKey() final  bool postomat;

/// Create a copy of NpBranch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpBranchCopyWith<_NpBranch> get copyWith => __$NpBranchCopyWithImpl<_NpBranch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpBranchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpBranch&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.name, name) || other.name == name)&&(identical(other.number, number) || other.number == number)&&(identical(other.postomat, postomat) || other.postomat == postomat));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,name,number,postomat);
}

@override
String toString() {
    return 'NpBranch(ref: $ref, name: $name, number: $number, postomat: $postomat)';
}


}

/// @nodoc
abstract mixin class _$NpBranchCopyWith<$Res> implements $NpBranchCopyWith<$Res> {
  factory _$NpBranchCopyWith(_NpBranch value, $Res Function(_NpBranch) _then) = __$NpBranchCopyWithImpl;
@override @useResult
$Res call({
 String? ref, String? name, String? number, bool postomat
});




}
/// @nodoc
class __$NpBranchCopyWithImpl<$Res>
    implements _$NpBranchCopyWith<$Res> {
  __$NpBranchCopyWithImpl(this._self, this._then);

  final _NpBranch _self;
  final $Res Function(_NpBranch) _then;

/// Create a copy of NpBranch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = freezed,Object? name = freezed,Object? number = freezed,Object? postomat = null,}) {
  return _then(_NpBranch(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,number: freezed == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String?,postomat: null == postomat ? _self.postomat : postomat // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$NpStreet {

 String? get ref; String? get name; String? get type;
/// Create a copy of NpStreet
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpStreetCopyWith<NpStreet> get copyWith => _$NpStreetCopyWithImpl<NpStreet>(this as NpStreet, _$identity);

  /// Serializes this NpStreet to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpStreet;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpStreet&&(identical(other.ref, _this.ref) || other.ref == _this.ref)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpStreet;
  return Object.hash(runtimeType,_this.ref,_this.name,_this.type);
}

@override
String toString() {
  final _this = this as NpStreet;
  return 'NpStreet(ref: ${_this.ref}, name: ${_this.name}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $NpStreetCopyWith<$Res>  {
  factory $NpStreetCopyWith(NpStreet value, $Res Function(NpStreet) _then) = _$NpStreetCopyWithImpl;
@useResult
$Res call({
 String? ref, String? name, String? type
});




}
/// @nodoc
class _$NpStreetCopyWithImpl<$Res>
    implements $NpStreetCopyWith<$Res> {
  _$NpStreetCopyWithImpl(this._self, this._then);

  final NpStreet _self;
  final $Res Function(NpStreet) _then;

/// Create a copy of NpStreet
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ref = freezed,Object? name = freezed,Object? type = freezed,}) {
  return _then(NpStreet(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NpStreet].
extension NpStreetPatterns on NpStreet {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpStreet value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpStreet() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpStreet value)  $default,){
final _that = this;
switch (_that) {
case _NpStreet():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpStreet value)?  $default,){
final _that = this;
switch (_that) {
case _NpStreet() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpStreet() when $default != null:
return $default(_that.ref,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? ref,  String? name,  String? type)  $default,) {final _that = this;
switch (_that) {
case _NpStreet():
return $default(_that.ref,_that.name,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? ref,  String? name,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _NpStreet() when $default != null:
return $default(_that.ref,_that.name,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpStreet implements NpStreet {
  const _NpStreet({this.ref, this.name, this.type});
  factory _NpStreet.fromJson(Map<String, dynamic> json) => _$NpStreetFromJson(json);

@override final  String? ref;
@override final  String? name;
@override final  String? type;

/// Create a copy of NpStreet
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpStreetCopyWith<_NpStreet> get copyWith => __$NpStreetCopyWithImpl<_NpStreet>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpStreetToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpStreet&&(identical(other.ref, ref) || other.ref == ref)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ref,name,type);
}

@override
String toString() {
    return 'NpStreet(ref: $ref, name: $name, type: $type)';
}


}

/// @nodoc
abstract mixin class _$NpStreetCopyWith<$Res> implements $NpStreetCopyWith<$Res> {
  factory _$NpStreetCopyWith(_NpStreet value, $Res Function(_NpStreet) _then) = __$NpStreetCopyWithImpl;
@override @useResult
$Res call({
 String? ref, String? name, String? type
});




}
/// @nodoc
class __$NpStreetCopyWithImpl<$Res>
    implements _$NpStreetCopyWith<$Res> {
  __$NpStreetCopyWithImpl(this._self, this._then);

  final _NpStreet _self;
  final $Res Function(_NpStreet) _then;

/// Create a copy of NpStreet
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ref = freezed,Object? name = freezed,Object? type = freezed,}) {
  return _then(_NpStreet(
ref: freezed == ref ? _self.ref : ref // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
