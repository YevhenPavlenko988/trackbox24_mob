import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/app/app.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/config/app_config.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/core/storage/secure_store.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  // A server override from the dev menu must be known before the first request.
  final storedBaseUrl = config.isDev ? await SecureStore().readBaseUrl() : null;
  runApp(
    ProviderScope(
      // Riverpod retries a failed provider ten times with backoff, which turns a 403 or a 404 into a minute of
      // spinner. A server answer is final; a lost connection gets two quick tries, then the error (the offline
      // cache has already answered where it could), so nothing hangs in a basement.
      retry: (count, error) => error is ApiException
          ? (error.isTransport && count < 2
                ? const Duration(milliseconds: 500)
                : null)
          : ProviderContainer.defaultRetry(count, error),
      overrides: [
        appConfigProvider.overrideWithValue(config),
        baseUrlOverrideProvider.overrideWith(
          () => BaseUrlOverride(storedBaseUrl),
        ),
      ],
      child: const TrackBoxApp(),
    ),
  );
}
