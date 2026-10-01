import 'package:dio/dio.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';

/// Converts any Dio failure into an [ApiException].
///
/// The backend answers errors as RFC 7807 problem+json (`title`, `status`, `detail`,
/// `errors{field: message}`), except 401/403 from Spring Security, which have an empty body.
ApiException toApiException(Object error) {
  if (error is ApiException) return error;
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException.timeout();
      case DioExceptionType.connectionError:
        return const ApiException.network();
      case DioExceptionType.badResponse:
        return parseProblem(error.response!.statusCode, error.response!.data);
      // ignore: no_default_cases — new DioExceptionType values should fall through to the generic path
      default:
        if (error.response != null) {
          return parseProblem(error.response!.statusCode, error.response!.data);
        }
        return const ApiException.network();
    }
  }
  return ApiException(kind: ApiErrorKind.http, detail: error.toString());
}

const _knownKeys = {'type', 'title', 'status', 'detail', 'instance', 'errors'};

ApiException parseProblem(int? status, Object? body) {
  if (body is Map) {
    final map = body.cast<String, dynamic>();
    final errors = <String, String>{};
    final rawErrors = map['errors'];
    if (rawErrors is Map) {
      rawErrors.forEach((k, v) => errors['$k'] = v is List ? v.join(', ') : '$v');
    }
    final extensions = <String, dynamic>{
      for (final e in map.entries)
        if (!_knownKeys.contains(e.key)) e.key: e.value,
    };
    return ApiException(
      kind: ApiErrorKind.http,
      status: (map['status'] as num?)?.toInt() ?? status,
      title: map['title'] as String?,
      detail: map['detail'] as String?,
      fieldErrors: errors,
      extensions: extensions,
    );
  }
  return ApiException(kind: ApiErrorKind.http, status: status);
}
