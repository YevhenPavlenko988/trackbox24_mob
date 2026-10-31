// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel_photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ParcelPhoto _$ParcelPhotoFromJson(Map<String, dynamic> json) => _ParcelPhoto(
  id: (json['id'] as num).toInt(),
  url: json['url'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
  urlExpiresAt: json['urlExpiresAt'] == null
      ? null
      : DateTime.parse(json['urlExpiresAt'] as String),
  width: (json['width'] as num?)?.toInt(),
  height: (json['height'] as num?)?.toInt(),
  sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
  createdBy: json['createdBy'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  seatNumber: (json['seatNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$ParcelPhotoToJson(_ParcelPhoto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'thumbnailUrl': instance.thumbnailUrl,
      'urlExpiresAt': instance.urlExpiresAt?.toIso8601String(),
      'width': instance.width,
      'height': instance.height,
      'sizeBytes': instance.sizeBytes,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt?.toIso8601String(),
      'seatNumber': instance.seatNumber,
    };
