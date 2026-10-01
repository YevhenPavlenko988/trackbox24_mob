/// Error returned by the backend (RFC 7807 problem+json) or by the transport.
class ApiException implements Exception {
  const ApiException({
    required this.kind,
    this.status,
    this.title,
    this.detail,
    this.fieldErrors = const {},
    this.extensions = const {},
  });

  const ApiException.network() : this(kind: ApiErrorKind.network);
  const ApiException.timeout() : this(kind: ApiErrorKind.timeout);

  final ApiErrorKind kind;
  final int? status;

  /// Backend `title` (English), e.g. "Parcels left in the car".
  final String? title;

  /// Backend `detail` (English, sometimes Ukrainian) — shown to the user when present.
  final String? detail;

  /// Validation errors by field name (`errors` map).
  final Map<String, String> fieldErrors;

  /// Any extra top-level fields of the problem body (e.g. `undeliveredParcels`).
  final Map<String, dynamic> extensions;

  bool get isUnauthorized => status == 401;
  bool get isForbidden => status == 403;
  bool get isNotFound => status == 404;
  bool get isConflict => status == 409;
  bool get isValidation => status == 400 && fieldErrors.isNotEmpty;

  /// Transport failures (no response) — the offline queue keeps these for retry.
  bool get isTransport => kind == ApiErrorKind.network || kind == ApiErrorKind.timeout;

  @override
  String toString() => 'ApiException($kind, $status, $title, $detail)';
}

enum ApiErrorKind { network, timeout, http }
