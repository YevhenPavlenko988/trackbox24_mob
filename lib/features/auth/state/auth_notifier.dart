import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/auth/data/auth_api.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';

sealed class AuthState {
  const AuthState();
}

/// Token being read from secure storage / `me` being fetched on startup.
class AuthLoading extends AuthState {
  const AuthLoading();
}

class Unauthenticated extends AuthState {
  const Unauthenticated({this.expired = false});

  /// True when the session ended by itself (401 / token TTL), so the login screen can say so.
  final bool expired;
}

class Authenticated extends AuthState {
  const Authenticated(this.user);

  final User user;
}

final authApiProvider = Provider<AuthApi>(
  (ref) => AuthApi(ref.watch(dioProvider)),
);

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    unawaited(Future.microtask(_restore));
    return const AuthLoading();
  }

  Future<void> _restore() async {
    final store = ref.read(secureStoreProvider);
    final token = await store.readToken();
    final expiresAt = await store.readTokenExpiresAt();
    if (token == null ||
        (expiresAt != null && expiresAt.isBefore(DateTime.now()))) {
      await store.clearToken();
      state = Unauthenticated(expired: token != null);
      return;
    }
    try {
      state = Authenticated(await ref.read(authApiProvider).me());
    } on ApiException catch (e) {
      if (e.isUnauthorized || e.isForbidden) {
        await store.clearToken();
        state = const Unauthenticated(expired: true);
      } else {
        // Offline at startup: keep the token, let the app open; requests will fail until online.
        state = const Authenticated(
          User(id: 0, email: '', roles: [Role.REPRESENTATIVE, Role.DRIVER]),
        );
        _retryMeLater();
      }
    }
  }

  void _retryMeLater() {
    Future<void>.delayed(const Duration(seconds: 15), () async {
      if (state is! Authenticated) return;
      try {
        state = Authenticated(await ref.read(authApiProvider).me());
      } on ApiException catch (e) {
        if (e.isUnauthorized) {
          await expire();
        } else {
          _retryMeLater();
        }
      }
    });
  }

  Future<void> login({required String email, required String password}) async {
    final api = ref.read(authApiProvider);
    final token = await api.login(email: email, password: password);
    await ref
        .read(secureStoreProvider)
        .writeToken(
          token.accessToken,
          expiresAt: DateTime.now().add(Duration(seconds: token.expiresIn)),
        );
    state = Authenticated(await api.me());
  }

  Future<void> logout() async {
    await ref.read(secureStoreProvider).clearToken();
    state = const Unauthenticated();
  }

  /// Called by the auth interceptor on 401: the token is gone, the user must log in again.
  Future<void> expire() async {
    if (state is! Authenticated) return;
    await ref.read(secureStoreProvider).clearToken();
    state = const Unauthenticated(expired: true);
  }
}
