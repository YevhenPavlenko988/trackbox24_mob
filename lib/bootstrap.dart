import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/app/app.dart';
import 'package:trackbox24_mob/core/config/app_config.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/core/storage/secure_store.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  // A server override from the dev menu must be known before the first request.
  final storedBaseUrl = config.isDev ? await SecureStore().readBaseUrl() : null;
  runApp(
    ProviderScope(
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
