import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/auth/ui/login_screen.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_screen.dart';
import 'package:trackbox24_mob/features/settings/ui/settings_screen.dart';
import 'package:trackbox24_mob/features/shell/placeholder_screen.dart';
import 'package:trackbox24_mob/features/shell/role_shell.dart';
import 'package:trackbox24_mob/features/shell/web_only_screen.dart';

class Routes {
  static const splash = '/splash';
  static const login = '/login';
  static const webOnly = '/web-only';
  static const toReceive = '/rep/to-receive';
  static const received = '/rep/received';
  static const trips = '/drv/trips';
  static const scan = '/scan';
  static const queue = '/queue';
  static const more = '/more';
}

/// Rebuilds the router's redirect whenever auth state changes.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(Ref ref) {
    ref.listen<AuthState>(authProvider, (_, _) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: listenable,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final loc = state.matchedLocation;
      switch (auth) {
        case AuthLoading():
          return loc == Routes.splash ? null : Routes.splash;
        case Unauthenticated():
          return loc == Routes.login ? null : Routes.login;
        case Authenticated(:final user):
          if (!user.canUseMobile) {
            return loc == Routes.webOnly ? null : Routes.webOnly;
          }
          if (loc == Routes.splash ||
              loc == Routes.login ||
              loc == Routes.webOnly) {
            return user.isRepresentative ? Routes.toReceive : Routes.trips;
          }
          return null;
      }
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const _Splash()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.webOnly, builder: (_, _) => const WebOnlyScreen()),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => RoleShell(navigationShell: shell),
        branches: [
          _branch(Routes.toReceive, (l) => l.screen_toReceive),
          _branch(Routes.received, (l) => l.nav_received),
          _branch(Routes.trips, (l) => l.nav_trips),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.scan, builder: (_, _) => const ScanScreen()),
            ],
          ),
          _branch(Routes.queue, (l) => l.nav_queue),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.more,
                builder: (_, _) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

StatefulShellBranch _branch(
  String path,
  String Function(AppLocalizations) title,
) => StatefulShellBranch(
  routes: [
    GoRoute(
      path: path,
      builder: (context, _) =>
          PlaceholderScreen(title: title(AppLocalizations.of(context))),
    ),
  ],
);

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
