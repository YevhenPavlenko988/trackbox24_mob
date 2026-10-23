import 'package:freezed_annotation/freezed_annotation.dart';

part 'parcel_photo_model.freezed.dart';
part 'parcel_photo_model.g.dart';

/// A parcel may carry this many photos, counting the ones already there.
const maxParcelPhotos = 3;

/// How long the backend keeps a delivered parcel's photos after hand-over.
const photoRetention = Duration(days: 14);

/// One photo of a parcel. Both links are presigned and die at [urlExpiresAt]; the photo itself never changes,
/// so images are cached by [id] (`photo-<id>` / `thumb-<id>`), never by the link.
@freezed
abstract class ParcelPhoto with _$ParcelPhoto {
  const factory ParcelPhoto({
    required int id,
    required String url,
    required String thumbnailUrl,
    DateTime? urlExpiresAt,
    int? width,
    int? height,
    int? sizeBytes,
    String? createdBy,
    DateTime? createdAt,
  }) = _ParcelPhoto;
  const ParcelPhoto._();

  factory ParcelPhoto.fromJson(Map<String, dynamic> json) =>
      _$ParcelPhotoFromJson(json);

  bool get linksExpired =>
      urlExpiresAt != null && urlExpiresAt!.isBefore(DateTime.now());
}
