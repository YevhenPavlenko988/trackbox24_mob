// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parcel_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParcelListKey implements DiagnosticableTreeMixin {

 ParcelStatus? get status; int? get representativeId; bool? get needsEnrichment; String? get sort; String get query;
/// Create a copy of ParcelListKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelListKeyCopyWith<ParcelListKey> get copyWith => _$ParcelListKeyCopyWithImpl<ParcelListKey>(this as ParcelListKey, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as ParcelListKey;
  properties
    ..add(DiagnosticsProperty('type', 'ParcelListKey'))
    ..add(DiagnosticsProperty('status', _this.status))..add(DiagnosticsProperty('representativeId', _this.representativeId))..add(DiagnosticsProperty('needsEnrichment', _this.needsEnrichment))..add(DiagnosticsProperty('sort', _this.sort))..add(DiagnosticsProperty('query', _this.query));
}

@override
bool operator ==(Object other) {
  final _this = this as ParcelListKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParcelListKey&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.representativeId, _this.representativeId) || other.representativeId == _this.representativeId)&&(identical(other.needsEnrichment, _this.needsEnrichment) || other.needsEnrichment == _this.needsEnrichment)&&(identical(other.sort, _this.sort) || other.sort == _this.sort)&&(identical(other.query, _this.query) || other.query == _this.query));
}


@override
int get hashCode {
  final _this = this as ParcelListKey;
  return Object.hash(runtimeType,_this.status,_this.representativeId,_this.needsEnrichment,_this.sort,_this.query);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as ParcelListKey;
  return 'ParcelListKey(status: ${_this.status}, representativeId: ${_this.representativeId}, needsEnrichment: ${_this.needsEnrichment}, sort: ${_this.sort}, query: ${_this.query})';
}


}

/// @nodoc
abstract mixin class $ParcelListKeyCopyWith<$Res>  {
  factory $ParcelListKeyCopyWith(ParcelListKey value, $Res Function(ParcelListKey) _then) = _$ParcelListKeyCopyWithImpl;
@useResult
$Res call({
 ParcelStatus? status, int? representativeId, bool? needsEnrichment, String? sort, String query
});




}
/// @nodoc
class _$ParcelListKeyCopyWithImpl<$Res>
    implements $ParcelListKeyCopyWith<$Res> {
  _$ParcelListKeyCopyWithImpl(this._self, this._then);

  final ParcelListKey _self;
  final $Res Function(ParcelListKey) _then;

/// Create a copy of ParcelListKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? representativeId = freezed,Object? needsEnrichment = freezed,Object? sort = freezed,Object? query = null,}) {
  return _then(ParcelListKey(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,representativeId: freezed == representativeId ? _self.representativeId : representativeId // ignore: cast_nullable_to_non_nullable
as int?,needsEnrichment: freezed == needsEnrichment ? _self.needsEnrichment : needsEnrichment // ignore: cast_nullable_to_non_nullable
as bool?,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParcelListKey].
extension ParcelListKeyPatterns on ParcelListKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParcelListKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParcelListKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParcelListKey value)  $default,){
final _that = this;
switch (_that) {
case _ParcelListKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParcelListKey value)?  $default,){
final _that = this;
switch (_that) {
case _ParcelListKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ParcelStatus? status,  int? representativeId,  bool? needsEnrichment,  String? sort,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParcelListKey() when $default != null:
return $default(_that.status,_that.representativeId,_that.needsEnrichment,_that.sort,_that.query);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ParcelStatus? status,  int? representativeId,  bool? needsEnrichment,  String? sort,  String query)  $default,) {final _that = this;
switch (_that) {
case _ParcelListKey():
return $default(_that.status,_that.representativeId,_that.needsEnrichment,_that.sort,_that.query);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ParcelStatus? status,  int? representativeId,  bool? needsEnrichment,  String? sort,  String query)?  $default,) {final _that = this;
switch (_that) {
case _ParcelListKey() when $default != null:
return $default(_that.status,_that.representativeId,_that.needsEnrichment,_that.sort,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _ParcelListKey with DiagnosticableTreeMixin implements ParcelListKey {
  const _ParcelListKey({this.status, this.representativeId, this.needsEnrichment, this.sort, this.query = ''});
  

@override final  ParcelStatus? status;
@override final  int? representativeId;
@override final  bool? needsEnrichment;
@override final  String? sort;
@override@JsonKey() final  String query;

/// Create a copy of ParcelListKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelListKeyCopyWith<_ParcelListKey> get copyWith => __$ParcelListKeyCopyWithImpl<_ParcelListKey>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'ParcelListKey'))
    ..add(DiagnosticsProperty('status', status))..add(DiagnosticsProperty('representativeId', representativeId))..add(DiagnosticsProperty('needsEnrichment', needsEnrichment))..add(DiagnosticsProperty('sort', sort))..add(DiagnosticsProperty('query', query));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParcelListKey&&(identical(other.status, status) || other.status == status)&&(identical(other.representativeId, representativeId) || other.representativeId == representativeId)&&(identical(other.needsEnrichment, needsEnrichment) || other.needsEnrichment == needsEnrichment)&&(identical(other.sort, sort) || other.sort == sort)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode {
    return Object.hash(runtimeType,status,representativeId,needsEnrichment,sort,query);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'ParcelListKey(status: $status, representativeId: $representativeId, needsEnrichment: $needsEnrichment, sort: $sort, query: $query)';
}


}

/// @nodoc
abstract mixin class _$ParcelListKeyCopyWith<$Res> implements $ParcelListKeyCopyWith<$Res> {
  factory _$ParcelListKeyCopyWith(_ParcelListKey value, $Res Function(_ParcelListKey) _then) = __$ParcelListKeyCopyWithImpl;
@override @useResult
$Res call({
 ParcelStatus? status, int? representativeId, bool? needsEnrichment, String? sort, String query
});




}
/// @nodoc
class __$ParcelListKeyCopyWithImpl<$Res>
    implements _$ParcelListKeyCopyWith<$Res> {
  __$ParcelListKeyCopyWithImpl(this._self, this._then);

  final _ParcelListKey _self;
  final $Res Function(_ParcelListKey) _then;

/// Create a copy of ParcelListKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? representativeId = freezed,Object? needsEnrichment = freezed,Object? sort = freezed,Object? query = null,}) {
  return _then(_ParcelListKey(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ParcelStatus?,representativeId: freezed == representativeId ? _self.representativeId : representativeId // ignore: cast_nullable_to_non_nullable
as int?,needsEnrichment: freezed == needsEnrichment ? _self.needsEnrichment : needsEnrichment // ignore: cast_nullable_to_non_nullable
as bool?,sort: freezed == sort ? _self.sort : sort // ignore: cast_nullable_to_non_nullable
as String?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ParcelListState implements DiagnosticableTreeMixin {

 List<Parcel> get items; bool get hasMore; int get totalElements; bool get loadingMore; int get nextPage;
/// Create a copy of ParcelListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParcelListStateCopyWith<ParcelListState> get copyWith => _$ParcelListStateCopyWithImpl<ParcelListState>(this as ParcelListState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  final _this = this as ParcelListState;
  properties
    ..add(DiagnosticsProperty('type', 'ParcelListState'))
    ..add(DiagnosticsProperty('items', _this.items))..add(DiagnosticsProperty('hasMore', _this.hasMore))..add(DiagnosticsProperty('totalElements', _this.totalElements))..add(DiagnosticsProperty('loadingMore', _this.loadingMore))..add(DiagnosticsProperty('nextPage', _this.nextPage));
}

@override
bool operator ==(Object other) {
  final _this = this as ParcelListState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParcelListState&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.hasMore, _this.hasMore) || other.hasMore == _this.hasMore)&&(identical(other.totalElements, _this.totalElements) || other.totalElements == _this.totalElements)&&(identical(other.loadingMore, _this.loadingMore) || other.loadingMore == _this.loadingMore)&&(identical(other.nextPage, _this.nextPage) || other.nextPage == _this.nextPage));
}


@override
int get hashCode {
  final _this = this as ParcelListState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.hasMore,_this.totalElements,_this.loadingMore,_this.nextPage);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  final _this = this as ParcelListState;
  return 'ParcelListState(items: ${_this.items}, hasMore: ${_this.hasMore}, totalElements: ${_this.totalElements}, loadingMore: ${_this.loadingMore}, nextPage: ${_this.nextPage})';
}


}

/// @nodoc
abstract mixin class $ParcelListStateCopyWith<$Res>  {
  factory $ParcelListStateCopyWith(ParcelListState value, $Res Function(ParcelListState) _then) = _$ParcelListStateCopyWithImpl;
@useResult
$Res call({
 List<Parcel> items, bool hasMore, int totalElements, bool loadingMore, int nextPage
});




}
/// @nodoc
class _$ParcelListStateCopyWithImpl<$Res>
    implements $ParcelListStateCopyWith<$Res> {
  _$ParcelListStateCopyWithImpl(this._self, this._then);

  final ParcelListState _self;
  final $Res Function(ParcelListState) _then;

/// Create a copy of ParcelListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? hasMore = null,Object? totalElements = null,Object? loadingMore = null,Object? nextPage = null,}) {
  return _then(ParcelListState(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Parcel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ParcelListState].
extension ParcelListStatePatterns on ParcelListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParcelListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParcelListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParcelListState value)  $default,){
final _that = this;
switch (_that) {
case _ParcelListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParcelListState value)?  $default,){
final _that = this;
switch (_that) {
case _ParcelListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Parcel> items,  bool hasMore,  int totalElements,  bool loadingMore,  int nextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParcelListState() when $default != null:
return $default(_that.items,_that.hasMore,_that.totalElements,_that.loadingMore,_that.nextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Parcel> items,  bool hasMore,  int totalElements,  bool loadingMore,  int nextPage)  $default,) {final _that = this;
switch (_that) {
case _ParcelListState():
return $default(_that.items,_that.hasMore,_that.totalElements,_that.loadingMore,_that.nextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Parcel> items,  bool hasMore,  int totalElements,  bool loadingMore,  int nextPage)?  $default,) {final _that = this;
switch (_that) {
case _ParcelListState() when $default != null:
return $default(_that.items,_that.hasMore,_that.totalElements,_that.loadingMore,_that.nextPage);case _:
  return null;

}
}

}

/// @nodoc


class _ParcelListState with DiagnosticableTreeMixin implements ParcelListState {
  const _ParcelListState({required  List<Parcel> items, required this.hasMore, required this.totalElements, this.loadingMore = false, this.nextPage = 0}): _items = items;
  

 final  List<Parcel> _items;
@override List<Parcel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  bool hasMore;
@override final  int totalElements;
@override@JsonKey() final  bool loadingMore;
@override@JsonKey() final  int nextPage;

/// Create a copy of ParcelListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParcelListStateCopyWith<_ParcelListState> get copyWith => __$ParcelListStateCopyWithImpl<_ParcelListState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
    ..add(DiagnosticsProperty('type', 'ParcelListState'))
    ..add(DiagnosticsProperty('items', items))..add(DiagnosticsProperty('hasMore', hasMore))..add(DiagnosticsProperty('totalElements', totalElements))..add(DiagnosticsProperty('loadingMore', loadingMore))..add(DiagnosticsProperty('nextPage', nextPage));
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParcelListState&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totalElements, totalElements) || other.totalElements == totalElements)&&(identical(other.loadingMore, loadingMore) || other.loadingMore == loadingMore)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),hasMore,totalElements,loadingMore,nextPage);
}

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
    return 'ParcelListState(items: $items, hasMore: $hasMore, totalElements: $totalElements, loadingMore: $loadingMore, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class _$ParcelListStateCopyWith<$Res> implements $ParcelListStateCopyWith<$Res> {
  factory _$ParcelListStateCopyWith(_ParcelListState value, $Res Function(_ParcelListState) _then) = __$ParcelListStateCopyWithImpl;
@override @useResult
$Res call({
 List<Parcel> items, bool hasMore, int totalElements, bool loadingMore, int nextPage
});




}
/// @nodoc
class __$ParcelListStateCopyWithImpl<$Res>
    implements _$ParcelListStateCopyWith<$Res> {
  __$ParcelListStateCopyWithImpl(this._self, this._then);

  final _ParcelListState _self;
  final $Res Function(_ParcelListState) _then;

/// Create a copy of ParcelListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? hasMore = null,Object? totalElements = null,Object? loadingMore = null,Object? nextPage = null,}) {
  return _then(_ParcelListState(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Parcel>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalElements: null == totalElements ? _self.totalElements : totalElements // ignore: cast_nullable_to_non_nullable
as int,loadingMore: null == loadingMore ? _self.loadingMore : loadingMore // ignore: cast_nullable_to_non_nullable
as bool,nextPage: null == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
