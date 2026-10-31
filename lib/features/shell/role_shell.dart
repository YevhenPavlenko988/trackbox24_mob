import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';

/// Bottom-navigation shell. Tabs depend on the user's roles: a user with both
/// REPRESENTATIVE and DRIVER sees the union.
class RoleShell extends ConsumerWidget {
  const RoleShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    ref.watch(offlineWarmUpProvider);
    final tabs = shellTabs(user, parcels: ref.watch(parcelsEnabledProvider));
    final pending = ref.watch(pendingCountProvider).value ?? 0;
    final current = tabs.indexWhere(
      (t) => t.branch == navigationShell.currentIndex,
    );
    // The branch shown has no tab (a representative of a moves-only company lands on «Забрати»): open the first tab.
    if (current < 0 && tabs.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => navigationShell.goBranch(tabs.first.branch),
      );
    }
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: current < 0 ? 0 : current,
        onDestinationSelected: (i) => navigationShell.goBranch(
          tabs[i].branch,
          initialLocation: tabs[i].branch == navigationShell.currentIndex,
        ),
        destinations: [
          for (final t in tabs)
            NavigationDestination(
              icon: t.branch == 4 && pending > 0
                  ? Badge.count(count: pending, child: Icon(t.icon))
                  : Icon(t.icon),
              label: t.label(l),
            ),
        ],
      ),
    );
  }
}

class ShellTab {
  const ShellTab(this.branch, this.icon, this.label);

  /// Index of the branch in the `StatefulShellRoute` (see router).
  final int branch;
  final IconData icon;
  final String Function(AppLocalizations) label;
}

/// Branch order in the router: 0 toReceive, 1 received, 2 trips, 3 scan, 4 queue, 5 more, 6 accepted.
/// Without [parcels] there is nothing to collect from Nova Poshta, so «Забрати» goes.
List<ShellTab> shellTabs(User? user, {bool parcels = true}) {
  final rep = user?.isRepresentative ?? false;
  final drv = user?.isDriver ?? false;
  return [
    if (rep && parcels)
      ShellTab(0, Icons.inbox_outlined, (l) => l.nav_toReceive),
    if (rep) ShellTab(1, Icons.inventory_2_outlined, (l) => l.nav_received),
    if (drv) ShellTab(2, Icons.local_shipping_outlined, (l) => l.nav_trips),
    // A representative's «Отримані» already lists what drivers accepted, so only a pure driver needs this tab.
    if (drv && !rep)
      ShellTab(6, Icons.inventory_2_outlined, (l) => l.nav_accepted),
    ShellTab(3, Icons.qr_code_scanner, (l) => l.nav_scan),
    ShellTab(4, Icons.cloud_upload_outlined, (l) => l.nav_queue),
    ShellTab(5, Icons.more_horiz, (l) => l.nav_more),
  ];
}

/// Asks once per session, while there is a connection, for what a scan without one needs: the trips to load into
/// and the warehouses. The offline cache keeps the answers, so the pickers work in airplane mode even when the
/// driver never opened them online. Failures are ignored: the pickers ask again themselves.
final offlineWarmUpProvider = FutureProvider<void>((ref) async {
  await Future.wait<Object?>([
    ref.read(tripsByStatusProvider(loadableTripStatuses).future),
    ref.read(activeWarehousesProvider.future),
  ]).catchError((_) => <Object?>[]);
});
