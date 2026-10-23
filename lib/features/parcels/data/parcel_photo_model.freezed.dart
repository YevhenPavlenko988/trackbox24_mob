// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_photo_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ParcelPhoto {

 int get id; String get url; String get thumbnailUrl; DateTime? get urlExpiresAt; int? get width; int? get height; int? get sizeBytes; String? get createdBy; DateTime? get createdAt;
/// Create a copy of ParcelPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelPhotoCopyWith<ParcelPhoto> get copyWith => _$ParcelPhotoCopyWithImpl<ParcelPhoto>(this as ParcelPhoto, _$identity);

  /// Serializes this ParcelPhoto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ParcelPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParcelPhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.urlExpiresAt, _this.urlExpiresAt) || other.urlExpiresAt == _this.urlExpiresAt)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.sizeBytes, _this.sizeBytes) || other.sizeBytes == _this.sizeBytes)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ParcelPhoto;
  return Object.hash(runtimeType,_this.id,_this.url,_this.thumbnailUrl,_this.urlExpiresAt,_this.width,_this.height,_this.sizeBytes,_this.createdBy,_this.createdAt);
}

@override
String toString() {
  final _this = this as ParcelPhoto;
  return 'ParcelPhoto(id: ${_this.id}, url: ${_this.url}, thumbnailUrl: ${_this.thumbnailUrl}, urlExpiresAt: ${_this.urlExpiresAt}, width: ${_this.width}, height: ${_this.height}, sizeBytes: ${_this.sizeBytes}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $ParcelPhotoCopyWith<$Res>  {
  factory $ParcelPhotoCopyWith(ParcelPhoto value, $Res Function(ParcelPhoto) _then) = _$ParcelPhotoCopyWithImpl;
@useResult
$Res call({
 int id, String url, String thumbnailUrl, DateTime? urlExpiresAt, int? width, int? height, int? sizeBytes, String? createdBy, DateTime? createdAt
});




}
/// @nodoc
class _$ParcelPhotoCopyWithImpl<$Res>
    implements $ParcelPhotoCopyWith<$Res> {
  _$ParcelPhotoCopyWithImpl(this._self, this._then);

  final ParcelPhoto _self;
  final $Res Function(ParcelPhoto) _then;

/// Create a copy of ParcelPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? urlExpiresAt = freezed,Object? width = freezed,Object? height = freezed,Object? sizeBytes = freezed,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(ParcelPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,urlExpiresAt: freezed == urlExpiresAt ? _self.urlExpiresAt : urlExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParcelPhoto].
extension ParcelPhotoPatterns on ParcelPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParcelPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParcelPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParcelPhoto value)  $default,){
final _that = this;
switch (_that) {
case _ParcelPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParcelPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _ParcelPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String url,  String thumbnailUrl,  DateTime? urlExpiresAt,  int? width,  int? height,  int? sizeBytes,  String? createdBy,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParcelPhoto() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.urlExpiresAt,_that.width,_that.height,_that.sizeBytes,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String url,  String thumbnailUrl,  DateTime? urlExpiresAt,  int? width,  int? height,  int? sizeBytes,  String? createdBy,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _ParcelPhoto():
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.urlExpiresAt,_that.width,_that.height,_that.sizeBytes,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String url,  String thumbnailUrl,  DateTime? urlExpiresAt,  int? width,  int? height,  int? sizeBytes,  String? createdBy,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ParcelPhoto() when $default != null:
return $default(_that.id,_that.url,_that.thumbnailUrl,_that.urlExpiresAt,_that.width,_that.height,_that.sizeBytes,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ParcelPhoto extends ParcelPhoto {
  const _ParcelPhoto({required this.id, required this.url, required this.thumbnailUrl, this.urlExpiresAt, this.width, this.height, this.sizeBytes, this.createdBy, this.createdAt}): super._();
  factory _ParcelPhoto.fromJson(Map<String, dynamic> json) => _$ParcelPhotoFromJson(json);

@override final  int id;
@override final  String url;
@override final  String thumbnailUrl;
@override final  DateTime? urlExpiresAt;
@override final  int? width;
@override final  int? height;
@override final  int? sizeBytes;
@override final  String? createdBy;
@override final  DateTime? createdAt;

/// Create a copy of ParcelPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelPhotoCopyWith<_ParcelPhoto> get copyWith => __$ParcelPhotoCopyWithImpl<_ParcelPhoto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParcelPhotoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParcelPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.urlExpiresAt, urlExpiresAt) || other.urlExpiresAt == urlExpiresAt)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,thumbnailUrl,urlExpiresAt,width,height,sizeBytes,createdBy,createdAt);
}

@override
String toString() {
    return 'ParcelPhoto(id: $id, url: $url, thumbnailUrl: $thumbnailUrl, urlExpiresAt: $urlExpiresAt, width: $width, height: $height, sizeBytes: $sizeBytes, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ParcelPhotoCopyWith<$Res> implements $ParcelPhotoCopyWith<$Res> {
  factory _$ParcelPhotoCopyWith(_ParcelPhoto value, $Res Function(_ParcelPhoto) _then) = __$ParcelPhotoCopyWithImpl;
@override @useResult
$Res call({
 int id, String url, String thumbnailUrl, DateTime? urlExpiresAt, int? width, int? height, int? sizeBytes, String? createdBy, DateTime? createdAt
});




}
/// @nodoc
class __$ParcelPhotoCopyWithImpl<$Res>
    implements _$ParcelPhotoCopyWith<$Res> {
  __$ParcelPhotoCopyWithImpl(this._self, this._then);

  final _ParcelPhoto _self;
  final $Res Function(_ParcelPhoto) _then;

/// Create a copy of ParcelPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbnailUrl = null,Object? urlExpiresAt = freezed,Object? width = freezed,Object? height = freezed,Object? sizeBytes = freezed,Object? createdBy = freezed,Object? createdAt = freezed,}) {
  return _then(_ParcelPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbnailUrl: null == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String,urlExpiresAt: freezed == urlExpiresAt ? _self.urlExpiresAt : urlExpiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,width: freezed == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int?,height: freezed == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
