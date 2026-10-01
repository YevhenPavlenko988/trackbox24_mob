import 'package:flutter/widgets.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';

/// User-facing message for an [ApiException]: backend `detail` when present, else a localized title by status.
String describeError(BuildContext context, Object error) {
  final l = AppLocalizations.of(context);
  if (error is! ApiException) return l.error_unknown;
  if (error.detail != null && error.detail!.isNotEmpty) return error.detail!;
  return switch (error.kind) {
    ApiErrorKind.network => l.error_network,
    ApiErrorKind.timeout => l.error_timeout,
    ApiErrorKind.http => switch (error.status) {
      400 =>
        error.fieldErrors.isNotEmpty
            ? error.fieldErrors.values.first
            : l.error_validation,
      401 => l.error_unauthorized,
      403 => l.error_forbidden,
      404 => l.error_notFound,
      409 => l.error_conflict,
      final s when s != null && s >= 500 => l.error_server,
      _ => l.error_unknown,
    },
  };
}
