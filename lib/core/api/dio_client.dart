import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';

Dio createDio({required String baseUrl, required AuthInterceptor auth}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: const {'Accept': 'application/json'},
      contentType: 'application/json',
      // Treat every status as a response; errors are raised by callers via toApiException.
      validateStatus: (s) => s != null && s >= 200 && s < 300,
    ),
  );
  dio.interceptors.add(auth);
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, logPrint: (o) => debugPrint('$o')),
    );
  }
  return dio;
}
