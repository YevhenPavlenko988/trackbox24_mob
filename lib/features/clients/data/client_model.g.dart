// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Client _$ClientFromJson(Map<String, dynamic> json) => _Client(
  id: (json['id'] as num).toInt(),
  type: $enumDecodeNullable(
    _$ClientTypeEnumMap,
    json['type'],
    unknownValue: ClientType.unknown,
  ),
  firstName: json['firstName'] as String?,
  lastName: json['lastName'] as String?,
  middleName: json['middleName'] as String?,
  organizationName: json['organizationName'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
  notes: json['notes'] as String?,
  channel: $enumDecodeNullable(
    _$ChannelEnumMap,
    json['channel'],
    unknownValue: Channel.unknown,
  ),
  channelDetails: json['channelDetails'] as String?,
);

Map<String, dynamic> _$ClientToJson(_Client instance) => <String, dynamic>{
  'id': instance.id,
  'type': _$ClientTypeEnumMap[instance.type],
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'middleName': instance.middleName,
  'organizationName': instance.organizationName,
  'phone': instance.phone,
  'email': instance.email,
  'city': instance.city,
  'address': instance.address,
  'notes': instance.notes,
  'channel': _$ChannelEnumMap[instance.channel],
  'channelDetails': instance.channelDetails,
};

const _$ClientTypeEnumMap = {
  ClientType.PRIVATE_PERSON: 'PRIVATE_PERSON',
  ClientType.ORGANIZATION: 'ORGANIZATION',
  ClientType.unknown: 'unknown',
};

const _$ChannelEnumMap = {
  Channel.TELEGRAM: 'TELEGRAM',
  Channel.VIBER: 'VIBER',
  Channel.WHATSAPP: 'WHATSAPP',
  Channel.INSTAGRAM: 'INSTAGRAM',
  Channel.FACEBOOK: 'FACEBOOK',
  Channel.TIKTOK: 'TIKTOK',
  Channel.WEBSITE: 'WEBSITE',
  Channel.PHONE_CALL: 'PHONE_CALL',
  Channel.REFERRAL: 'REFERRAL',
  Channel.OTHER: 'OTHER',
  Channel.unknown: 'unknown',
};
