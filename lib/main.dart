import 'package:trackbox24_mob/bootstrap.dart';
import 'package:trackbox24_mob/core/config/app_config.dart';

/// Single entry point; flavor and API URL come from `--dart-define` (see README).
void main() => bootstrap(AppConfig.fromEnvironment());
