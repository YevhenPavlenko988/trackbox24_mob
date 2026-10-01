import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';

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
    final tabs = shellTabs(user);
    final pending = ref.watch(pendingCountProvider).value ?? 0;
    final current = tabs.indexWhere(
      (t) => t.branch == navigationShell.currentIndex,
    );
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

/// Branch order in the router: 0 toReceive, 1 received, 2 trips, 3 scan, 4 queue, 5 more.
List<ShellTab> shellTabs(User? user) {
  final rep = user?.isRepresentative ?? false;
  final drv = user?.isDriver ?? false;
  return [
    if (rep) ShellTab(0, Icons.inbox_outlined, (l) => l.nav_toReceive),
    if (rep) ShellTab(1, Icons.inventory_2_outlined, (l) => l.nav_received),
    if (drv) ShellTab(2, Icons.local_shipping_outlined, (l) => l.nav_trips),
    ShellTab(3, Icons.qr_code_scanner, (l) => l.nav_scan),
    ShellTab(4, Icons.cloud_upload_outlined, (l) => l.nav_queue),
    ShellTab(5, Icons.more_horiz, (l) => l.nav_more),
  ];
}
