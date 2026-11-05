import 'package:image_picker/image_picker.dart';

/// The server keeps a photo at most 2048 px on the long side (WebP, quality 80), so the phone sends no more: a camera
/// original is many megabytes and on a slow link the upload broke off after a minute and a half.
const photoMaxSide = 2048.0;
const photoQuality = 85;

extension PhotoPick on ImagePicker {
  Future<XFile?> pickPhoto(ImageSource source) => pickImage(
    source: source,
    maxWidth: photoMaxSide,
    maxHeight: photoMaxSide,
    imageQuality: photoQuality,
  );

  Future<List<XFile>> pickPhotos({required int limit}) => pickMultiImage(
    limit: limit,
    maxWidth: photoMaxSide,
    maxHeight: photoMaxSide,
    imageQuality: photoQuality,
  );
}
