import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/app/app.dart';
import 'package:trackbox24_mob/core/config/app_config.dart';
import 'package:trackbox24_mob/core/providers.dart';

Future<void> bootstrap(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const TrackBoxApp(),
    ),
  );
}
