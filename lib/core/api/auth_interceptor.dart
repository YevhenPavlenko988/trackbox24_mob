import 'package:dio/dio.dart';

/// Adds `Authorization: Bearer` and reports 401s so the auth state can expire the session.
///
/// The backend has no refresh token: a 401 with a token present means it expired or was
/// revoked (password/role change), so the only recovery is a new login.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.readToken, required this.onUnauthorized});

  final Future<String?> Function() readToken;
  final Future<void> Function() onUnauthorized;

  static const _skipAuth = 'skipAuth';

  static Options skip() => Options(extra: const {_skipAuth: true});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[_skipAuth] != true) {
      final token = await readToken();
      if (token != null) options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra[_skipAuth] != true) {
      await onUnauthorized();
    }
    handler.next(err);
  }
}
