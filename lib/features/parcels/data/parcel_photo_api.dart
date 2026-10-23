import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_photo_model.dart';

class ParcelPhotoApi {
  ParcelPhotoApi(this._dio);

  final Dio _dio;

  Future<List<ParcelPhoto>> list(int parcelId) async {
    try {
      final res = await _dio.get<List<dynamic>>(
        '/api/parcels/$parcelId/photos',
      );
      return _photos(res.data);
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// One request for the whole pick, files as they are (HEIC too): the server converts, and keeps all or none.
  /// A phone photo is tens of megabytes on a slow link, so the timeouts are far above the client defaults.
  Future<List<ParcelPhoto>> add(int parcelId, List<XFile> files) async {
    try {
      final form = FormData();
      for (final f in files) {
        form.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(f.path, filename: f.name),
          ),
        );
      }
      final res = await _dio.post<List<dynamic>>(
        '/api/parcels/$parcelId/photos',
        data: form,
        options: Options(
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      return _photos(res.data);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<void> delete(int parcelId, int photoId) async {
    try {
      await _dio.delete<void>('/api/parcels/$parcelId/photos/$photoId');
    } catch (e) {
      throw toApiException(e);
    }
  }

  List<ParcelPhoto> _photos(List<dynamic>? data) => [
    for (final e in data ?? const [])
      ParcelPhoto.fromJson((e as Map).cast<String, dynamic>()),
  ];
}

final parcelPhotoApiProvider = Provider<ParcelPhotoApi>(
  (ref) => ParcelPhotoApi(ref.watch(dioProvider)),
);

final parcelPhotosProvider = FutureProvider.autoDispose
    .family<List<ParcelPhoto>, int>(
      (ref, id) => ref.watch(parcelPhotoApiProvider).list(id),
    );
