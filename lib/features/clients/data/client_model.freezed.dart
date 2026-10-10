// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Client {

 int get id;@JsonKey(unknownEnumValue: ClientType.unknown) ClientType? get type; String? get firstName; String? get lastName; String? get middleName; String? get organizationName; String? get phone; String? get email; String? get city; String? get address; String? get notes;@JsonKey(unknownEnumValue: Channel.unknown) Channel? get channel; String? get channelDetails; List<ClientMoney> get money;
/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientCopyWith<Client> get copyWith => _$ClientCopyWithImpl<Client>(this as Client, _$identity);

  /// Serializes this Client to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Client;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Client&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.middleName, _this.middleName) || other.middleName == _this.middleName)&&(identical(other.organizationName, _this.organizationName) || other.organizationName == _this.organizationName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.notes, _this.notes) || other.notes == _this.notes)&&(identical(other.channel, _this.channel) || other.channel == _this.channel)&&(identical(other.channelDetails, _this.channelDetails) || other.channelDetails == _this.channelDetails)&&const DeepCollectionEquality().equals(other.money, _this.money));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Client;
  return Object.hash(runtimeType,_this.id,_this.type,_this.firstName,_this.lastName,_this.middleName,_this.organizationName,_this.phone,_this.email,_this.city,_this.address,_this.notes,_this.channel,_this.channelDetails,const DeepCollectionEquality().hash(_this.money));
}

@override
String toString() {
  final _this = this as Client;
  return 'Client(id: ${_this.id}, type: ${_this.type}, firstName: ${_this.firstName}, lastName: ${_this.lastName}, middleName: ${_this.middleName}, organizationName: ${_this.organizationName}, phone: ${_this.phone}, email: ${_this.email}, city: ${_this.city}, address: ${_this.address}, notes: ${_this.notes}, channel: ${_this.channel}, channelDetails: ${_this.channelDetails}, money: ${_this.money})';
}


}

/// @nodoc
abstract mixin class $ClientCopyWith<$Res>  {
  factory $ClientCopyWith(Client value, $Res Function(Client) _then) = _$ClientCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: ClientType.unknown) ClientType? type, String? firstName, String? lastName, String? middleName, String? organizationName, String? phone, String? email, String? city, String? address, String? notes,@JsonKey(unknownEnumValue: Channel.unknown) Channel? channel, String? channelDetails, List<ClientMoney> money
});




}
/// @nodoc
class _$ClientCopyWithImpl<$Res>
    implements $ClientCopyWith<$Res> {
  _$ClientCopyWithImpl(this._self, this._then);

  final Client _self;
  final $Res Function(Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? middleName = freezed,Object? organizationName = freezed,Object? phone = freezed,Object? email = freezed,Object? city = freezed,Object? address = freezed,Object? notes = freezed,Object? channel = freezed,Object? channelDetails = freezed,Object? money = null,}) {
  return _then(Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClientType?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,organizationName: freezed == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,channelDetails: freezed == channelDetails ? _self.channelDetails : channelDetails // ignore: cast_nullable_to_non_nullable
as String?,money: null == money ? _self.money : money // ignore: cast_nullable_to_non_nullable
as List<ClientMoney>,
  ));
}

}


/// Adds pattern-matching-related methods to [Client].
extension ClientPatterns on Client {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Client value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Client value)  $default,){
final _that = this;
switch (_that) {
case _Client():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Client value)?  $default,){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: ClientType.unknown)  ClientType? type,  String? firstName,  String? lastName,  String? middleName,  String? organizationName,  String? phone,  String? email,  String? city,  String? address,  String? notes, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  List<ClientMoney> money)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.type,_that.firstName,_that.lastName,_that.middleName,_that.organizationName,_that.phone,_that.email,_that.city,_that.address,_that.notes,_that.channel,_that.channelDetails,_that.money);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(unknownEnumValue: ClientType.unknown)  ClientType? type,  String? firstName,  String? lastName,  String? middleName,  String? organizationName,  String? phone,  String? email,  String? city,  String? address,  String? notes, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  List<ClientMoney> money)  $default,) {final _that = this;
switch (_that) {
case _Client():
return $default(_that.id,_that.type,_that.firstName,_that.lastName,_that.middleName,_that.organizationName,_that.phone,_that.email,_that.city,_that.address,_that.notes,_that.channel,_that.channelDetails,_that.money);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(unknownEnumValue: ClientType.unknown)  ClientType? type,  String? firstName,  String? lastName,  String? middleName,  String? organizationName,  String? phone,  String? email,  String? city,  String? address,  String? notes, @JsonKey(unknownEnumValue: Channel.unknown)  Channel? channel,  String? channelDetails,  List<ClientMoney> money)?  $default,) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.type,_that.firstName,_that.lastName,_that.middleName,_that.organizationName,_that.phone,_that.email,_that.city,_that.address,_that.notes,_that.channel,_that.channelDetails,_that.money);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Client extends Client {
  const _Client({required this.id, @JsonKey(unknownEnumValue: ClientType.unknown) this.type, this.firstName, this.lastName, this.middleName, this.organizationName, this.phone, this.email, this.city, this.address, this.notes, @JsonKey(unknownEnumValue: Channel.unknown) this.channel, this.channelDetails,  List<ClientMoney> money = const []}): _money = money,super._();
  factory _Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

@override final  int id;
@override@JsonKey(unknownEnumValue: ClientType.unknown) final  ClientType? type;
@override final  String? firstName;
@override final  String? lastName;
@override final  String? middleName;
@override final  String? organizationName;
@override final  String? phone;
@override final  String? email;
@override final  String? city;
@override final  String? address;
@override final  String? notes;
@override@JsonKey(unknownEnumValue: Channel.unknown) final  Channel? channel;
@override final  String? channelDetails;
 final  List<ClientMoney> _money;
@override@JsonKey() List<ClientMoney> get money {
  if (_money is EqualUnmodifiableListView) return _money;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_money);
}


/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientCopyWith<_Client> get copyWith => __$ClientCopyWithImpl<_Client>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Client&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.organizationName, organizationName) || other.organizationName == organizationName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.city, city) || other.city == city)&&(identical(other.address, address) || other.address == address)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.channel, channel) || other.channel == channel)&&(identical(other.channelDetails, channelDetails) || other.channelDetails == channelDetails)&&const DeepCollectionEquality().equals(other.money, _money));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,type,firstName,lastName,middleName,organizationName,phone,email,city,address,notes,channel,channelDetails,const DeepCollectionEquality().hash(_money));
}

@override
String toString() {
    return 'Client(id: $id, type: $type, firstName: $firstName, lastName: $lastName, middleName: $middleName, organizationName: $organizationName, phone: $phone, email: $email, city: $city, address: $address, notes: $notes, channel: $channel, channelDetails: $channelDetails, money: $money)';
}


}

/// @nodoc
abstract mixin class _$ClientCopyWith<$Res> implements $ClientCopyWith<$Res> {
  factory _$ClientCopyWith(_Client value, $Res Function(_Client) _then) = __$ClientCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(unknownEnumValue: ClientType.unknown) ClientType? type, String? firstName, String? lastName, String? middleName, String? organizationName, String? phone, String? email, String? city, String? address, String? notes,@JsonKey(unknownEnumValue: Channel.unknown) Channel? channel, String? channelDetails, List<ClientMoney> money
});




}
/// @nodoc
class __$ClientCopyWithImpl<$Res>
    implements _$ClientCopyWith<$Res> {
  __$ClientCopyWithImpl(this._self, this._then);

  final _Client _self;
  final $Res Function(_Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = freezed,Object? firstName = freezed,Object? lastName = freezed,Object? middleName = freezed,Object? organizationName = freezed,Object? phone = freezed,Object? email = freezed,Object? city = freezed,Object? address = freezed,Object? notes = freezed,Object? channel = freezed,Object? channelDetails = freezed,Object? money = null,}) {
  return _then(_Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ClientType?,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,organizationName: freezed == organizationName ? _self.organizationName : organizationName // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as Channel?,channelDetails: freezed == channelDetails ? _self.channelDetails : channelDetails // ignore: cast_nullable_to_non_nullable
as String?,money: null == money ? _self._money : money // ignore: cast_nullable_to_non_nullable
as List<ClientMoney>,
  ));
}


}


/// @nodoc
mixin _$ClientMoney {

 String? get currency; double get total; double get paid; double get debt; double get upcoming;
/// Create a copy of ClientMoney
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientMoneyCopyWith<ClientMoney> get copyWith => _$ClientMoneyCopyWithImpl<ClientMoney>(this as ClientMoney, _$identity);

  /// Serializes this ClientMoney to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ClientMoney;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientMoney&&(identical(other.currency, _this.currency) || other.currency == _this.currency)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.paid, _this.paid) || other.paid == _this.paid)&&(identical(other.debt, _this.debt) || other.debt == _this.debt)&&(identical(other.upcoming, _this.upcoming) || other.upcoming == _this.upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ClientMoney;
  return Object.hash(runtimeType,_this.currency,_this.total,_this.paid,_this.debt,_this.upcoming);
}

@override
String toString() {
  final _this = this as ClientMoney;
  return 'ClientMoney(currency: ${_this.currency}, total: ${_this.total}, paid: ${_this.paid}, debt: ${_this.debt}, upcoming: ${_this.upcoming})';
}


}

/// @nodoc
abstract mixin class $ClientMoneyCopyWith<$Res>  {
  factory $ClientMoneyCopyWith(ClientMoney value, $Res Function(ClientMoney) _then) = _$ClientMoneyCopyWithImpl;
@useResult
$Res call({
 String? currency, double total, double paid, double debt, double upcoming
});




}
/// @nodoc
class _$ClientMoneyCopyWithImpl<$Res>
    implements $ClientMoneyCopyWith<$Res> {
  _$ClientMoneyCopyWithImpl(this._self, this._then);

  final ClientMoney _self;
  final $Res Function(ClientMoney) _then;

/// Create a copy of ClientMoney
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currency = freezed,Object? total = null,Object? paid = null,Object? debt = null,Object? upcoming = null,}) {
  return _then(ClientMoney(
currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as double,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as double,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientMoney].
extension ClientMoneyPatterns on ClientMoney {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientMoney value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientMoney() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientMoney value)  $default,){
final _that = this;
switch (_that) {
case _ClientMoney():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientMoney value)?  $default,){
final _that = this;
switch (_that) {
case _ClientMoney() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? currency,  double total,  double paid,  double debt,  double upcoming)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientMoney() when $default != null:
return $default(_that.currency,_that.total,_that.paid,_that.debt,_that.upcoming);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? currency,  double total,  double paid,  double debt,  double upcoming)  $default,) {final _that = this;
switch (_that) {
case _ClientMoney():
return $default(_that.currency,_that.total,_that.paid,_that.debt,_that.upcoming);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? currency,  double total,  double paid,  double debt,  double upcoming)?  $default,) {final _that = this;
switch (_that) {
case _ClientMoney() when $default != null:
return $default(_that.currency,_that.total,_that.paid,_that.debt,_that.upcoming);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientMoney implements ClientMoney {
  const _ClientMoney({this.currency, this.total = 0, this.paid = 0, this.debt = 0, this.upcoming = 0});
  factory _ClientMoney.fromJson(Map<String, dynamic> json) => _$ClientMoneyFromJson(json);

@override final  String? currency;
@override@JsonKey() final  double total;
@override@JsonKey() final  double paid;
@override@JsonKey() final  double debt;
@override@JsonKey() final  double upcoming;

/// Create a copy of ClientMoney
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientMoneyCopyWith<_ClientMoney> get copyWith => __$ClientMoneyCopyWithImpl<_ClientMoney>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientMoneyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientMoney&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.total, total) || other.total == total)&&(identical(other.paid, paid) || other.paid == paid)&&(identical(other.debt, debt) || other.debt == debt)&&(identical(other.upcoming, upcoming) || other.upcoming == upcoming));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,currency,total,paid,debt,upcoming);
}

@override
String toString() {
    return 'ClientMoney(currency: $currency, total: $total, paid: $paid, debt: $debt, upcoming: $upcoming)';
}


}

/// @nodoc
abstract mixin class _$ClientMoneyCopyWith<$Res> implements $ClientMoneyCopyWith<$Res> {
  factory _$ClientMoneyCopyWith(_ClientMoney value, $Res Function(_ClientMoney) _then) = __$ClientMoneyCopyWithImpl;
@override @useResult
$Res call({
 String? currency, double total, double paid, double debt, double upcoming
});




}
/// @nodoc
class __$ClientMoneyCopyWithImpl<$Res>
    implements _$ClientMoneyCopyWith<$Res> {
  __$ClientMoneyCopyWithImpl(this._self, this._then);

  final _ClientMoney _self;
  final $Res Function(_ClientMoney) _then;

/// Create a copy of ClientMoney
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currency = freezed,Object? total = null,Object? paid = null,Object? debt = null,Object? upcoming = null,}) {
  return _then(_ClientMoney(
currency: freezed == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,paid: null == paid ? _self.paid : paid // ignore: cast_nullable_to_non_nullable
as double,debt: null == debt ? _self.debt : debt // ignore: cast_nullable_to_non_nullable
as double,upcoming: null == upcoming ? _self.upcoming : upcoming // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
