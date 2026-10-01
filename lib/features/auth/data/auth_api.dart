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

  Future<User> me() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('/api/auth/me');
      return User.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}
