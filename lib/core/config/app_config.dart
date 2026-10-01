enum Flavor { dev, prod }

/// Build-time configuration, passed with `--dart-define`.
///
/// `flutter run --dart-define=FLAVOR=dev --dart-define=API_BASE_URL=http://192.168.1.10:8080`
class AppConfig {
  const AppConfig({required this.flavor, required this.apiBaseUrl});

  factory AppConfig.fromEnvironment() {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final flavor = Flavor.values.firstWhere(
      (f) => f.name == flavorName,
      orElse: () => Flavor.dev,
    );
    const url = String.fromEnvironment('API_BASE_URL');
    return AppConfig(
      flavor: flavor,
      apiBaseUrl: url.isNotEmpty ? url : _defaultUrl(flavor),
    );
  }

  final Flavor flavor;
  final String apiBaseUrl;

  bool get isDev => flavor == Flavor.dev;

  static String _defaultUrl(Flavor flavor) => switch (flavor) {
    // Android emulator reaches the host machine through 10.0.2.2; iOS simulator through localhost.
    Flavor.dev => 'http://localhost:8080',
    Flavor.prod => 'https://api.trackbox24.com',
  };
}
