import 'package:dio/dio.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<TokenResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/login',
        data: {'email': email, 'password': password},
        options: AuthInterceptor.skip(),
      );
      return TokenResponse.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// `POST /api/auth/password`: needs the current one, revokes every token issued before and returns a fresh one.
  Future<TokenResponse> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/auth/password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      );
      return TokenResponse.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<User> me() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/api/auth/me');
      return User.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}
