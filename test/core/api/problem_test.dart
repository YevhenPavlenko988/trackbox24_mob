import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/api/problem.dart';

DioException _response(int status, Object? body) => DioException(
  requestOptions: RequestOptions(path: '/x'),
  type: DioExceptionType.badResponse,
  response: Response(requestOptions: RequestOptions(path: '/x'), statusCode: status, data: body),
);

void main() {
  group('toApiException', () {
    test('parses problem+json with field errors', () {
      final e = toApiException(
        _response(400, {
          'type': 'about:blank',
          'title': 'Validation failed',
          'status': 400,
          'detail': 'Request has invalid fields',
          'errors': {'email': 'must not be blank', 'password': 'size must be between 8 and 72'},
        }),
      );
      expect(e.status, 400);
      expect(e.title, 'Validation failed');
      expect(e.detail, 'Request has invalid fields');
      expect(e.fieldErrors, {'email': 'must not be blank', 'password': 'size must be between 8 and 72'});
      expect(e.isValidation, isTrue);
      expect(e.extensions, isEmpty);
    });

    test('keeps unknown top-level fields as extensions (409 undeliveredParcels)', () {
      final e = toApiException(
        _response(409, {
          'title': 'Parcels left in the car',
          'status': 409,
          'undeliveredParcels': [
            {'id': 1, 'barcode': 'PT1234567890'},
          ],
        }),
      );
      expect(e.isConflict, isTrue);
      expect(e.extensions['undeliveredParcels'], hasLength(1));
    });

    test('empty 401 body from Spring Security', () {
      final e = toApiException(_response(401, ''));
      expect(e.status, 401);
      expect(e.isUnauthorized, isTrue);
      expect(e.detail, isNull);
      expect(e.isTransport, isFalse);
    });

    test('connection error is transport', () {
      final e = toApiException(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.connectionError),
      );
      expect(e.kind, ApiErrorKind.network);
      expect(e.isTransport, isTrue);
    });

    test('timeout is transport', () {
      final e = toApiException(
        DioException(requestOptions: RequestOptions(path: '/x'), type: DioExceptionType.receiveTimeout),
      );
      expect(e.kind, ApiErrorKind.timeout);
      expect(e.isTransport, isTrue);
    });

    test('passes ApiException through', () {
      const original = ApiException(kind: ApiErrorKind.http, status: 404);
      expect(identical(toApiException(original), original), isTrue);
    });
  });
}
