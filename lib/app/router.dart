import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/auth/ui/login_screen.dart';
import 'package:trackbox24_mob/features/clients/ui/client_detail_screen.dart';
import 'package:trackbox24_mob/features/clients/ui/client_form_screen.dart';
import 'package:trackbox24_mob/features/clients/ui/client_pick_screen.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_detail_screen.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_form_screen.dart';
import 'package:trackbox24_mob/features/parcels/ui/rep_lists.dart';
import 'package:trackbox24_mob/features/scan/ui/queue_screen.dart';
import 'package:trackbox24_mob/features/scan/ui/scan_screen.dart';
import 'package:trackbox24_mob/features/settings/ui/settings_screen.dart';
import 'package:trackbox24_mob/features/shell/role_shell.dart';
import 'package:trackbox24_mob/features/shell/web_only_screen.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_create_screen.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_detail_screen.dart';
import 'package:trackbox24_mob/features/trips/ui/trips_screen.dart';

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

final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = _AuthListenable(ref);
  ref.onDispose(listenable.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
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
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/parcels/new',
        builder: (_, _) => const ParcelFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/parcels/:id',
        builder: (_, s) =>
            ParcelDetailScreen(id: int.parse(s.pathParameters['id']!)),
        routes: [
          GoRoute(
            parentNavigatorKey: _rootKey,
            path: 'edit',
            builder: (_, s) =>
                ParcelFormScreen(id: int.parse(s.pathParameters['id']!)),
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/trips/new',
        builder: (_, _) => const TripCreateScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/trips/pick',
        builder: (_, _) => const TripPickScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/trips/:id',
        builder: (_, s) =>
            TripDetailScreen(id: int.parse(s.pathParameters['id']!)),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/scan/load/:tripId',
        builder: (_, s) =>
            ScanScreen(tripId: int.parse(s.pathParameters['tripId']!)),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/scan/deliver',
        builder: (_, _) => const ScanScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/clients/pick',
        builder: (_, _) => const ClientPickScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/clients/new',
        builder: (_, _) => const ClientFormScreen(),
      ),
      GoRoute(
        parentNavigatorKey: _rootKey,
        path: '/clients/:id',
        builder: (_, s) =>
            ClientDetailScreen(id: int.parse(s.pathParameters['id']!)),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => RoleShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.toReceive,
                builder: (_, _) => const ToReceiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.received,
                builder: (_, _) => const ReceivedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.trips,
                builder: (_, _) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.scan, builder: (_, _) => const ScanScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.queue,
                builder: (_, _) => const QueueScreen(),
              ),
            ],
          ),
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

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}
