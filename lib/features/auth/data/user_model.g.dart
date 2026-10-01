// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: (json['id'] as num).toInt(),
  email: json['email'] as String,
  roles:
      (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RoleEnumMap, e))
          .toList() ??
      const [],
  companyId: (json['companyId'] as num?)?.toInt(),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  phone: json['phone'] as String?,
  active: json['active'] as bool? ?? true,
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'roles': instance.roles.map((e) => _$RoleEnumMap[e]!).toList(),
  'companyId': instance.companyId,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'phone': instance.phone,
  'active': instance.active,
};

const _$RoleEnumMap = {
  Role.ADMIN: 'ADMIN',
  Role.MANAGER: 'MANAGER',
  Role.REPRESENTATIVE: 'REPRESENTATIVE',
  Role.DRIVER: 'DRIVER',
  Role.VIEWER: 'VIEWER',
};

_TokenResponse _$TokenResponseFromJson(Map<String, dynamic> json) =>
    _TokenResponse(
      accessToken: json['accessToken'] as String,
      tokenType: json['tokenType'] as String? ?? 'Bearer',
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 43200,
    );

Map<String, dynamic> _$TokenResponseToJson(_TokenResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
      'expiresIn': instance.expiresIn,
    };
