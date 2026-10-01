import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/page.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';

class ClientApi {
  ClientApi(this._dio);

  final Dio _dio;

  Future<Page<Client>> search(
    String text, {
    int page = 0,
    int size = 30,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/clients',
        queryParameters: {
          if (text.isNotEmpty) 'search': text,
          'sort': 'lastName,asc',
          'page': page,
          'size': size,
        },
      );
      return Page.fromJson(res.data!, Client.fromJson);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Client> get(int id) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/api/clients/$id');
      return Client.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// `POST /api/clients` — MANAGER and REPRESENTATIVE may create; editing is manager-only.
  Future<Client> create(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/clients',
        data: body,
      );
      return Client.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final clientApiProvider = Provider<ClientApi>(
  (ref) => ClientApi(ref.watch(dioProvider)),
);

final clientSearchProvider = FutureProvider.autoDispose
    .family<List<Client>, String>(
      (ref, text) async =>
          (await ref.watch(clientApiProvider).search(text)).content,
    );
