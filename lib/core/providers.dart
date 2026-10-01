import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/auth_interceptor.dart';
import 'package:trackbox24_mob/core/api/dio_client.dart';
import 'package:trackbox24_mob/core/config/app_config.dart';
import 'package:trackbox24_mob/core/storage/secure_store.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';

/// Overridden in `bootstrap()` with the real build-time config.
final appConfigProvider = Provider<AppConfig>(
  (_) => throw UnimplementedError('override in bootstrap'),
);

final secureStoreProvider = Provider<SecureStore>((_) => SecureStore());

/// Effective API base URL: a debug-menu override wins over the build-time value.
final baseUrlProvider = Provider<String>(
  (ref) => ref.watch(appConfigProvider).apiBaseUrl,
);

final dioProvider = Provider<Dio>((ref) {
  final store = ref.watch(secureStoreProvider);
  return createDio(
    baseUrl: ref.watch(baseUrlProvider),
    auth: AuthInterceptor(
      readToken: store.readToken,
      onUnauthorized: () => ref.read(authProvider.notifier).expire(),
    ),
  );
});
