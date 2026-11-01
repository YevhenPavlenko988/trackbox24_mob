import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
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
    final moves = ref.watch(movesEnabledProvider);
    final tabs = shellTabs(
      user,
      parcels: ref.watch(parcelsEnabledProvider),
      moves: moves,
    );
    final pending = ref.watch(pendingCountProvider).value ?? 0;
    // Without its own tab the queue opens from «Ще», so «Ще» stays lit and carries the badge.
    final queueBranch = queueInMore(user, moves: moves) ? 5 : 4;
    final shown = navigationShell.currentIndex == 4
        ? queueBranch
        : navigationShell.currentIndex;
    final current = tabs.indexWhere((t) => t.branch == shown);
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
              icon: t.branch == queueBranch && pending > 0
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

/// A representative with moves gets a «Переїзди» tab; five tabs is all the bar holds, so «Черга» moves into «Ще».
bool queueInMore(User? user, {required bool moves}) =>
    moves && (user?.isRepresentative ?? false);

/// Branch order in the router: 0 toReceive, 1 received, 2 trips, 3 scan, 4 queue, 5 more, 6 accepted, 7 moves.
/// Without [parcels] there is nothing to collect from Nova Poshta, so «Забрати» goes.
List<ShellTab> shellTabs(
  User? user, {
  bool parcels = true,
  bool moves = false,
}) {
  final rep = user?.isRepresentative ?? false;
  final drv = user?.isDriver ?? false;
  return [
    if (rep && parcels)
      ShellTab(0, Icons.inbox_outlined, (l) => l.nav_toReceive),
    if (rep) ShellTab(1, Icons.inventory_2_outlined, (l) => l.nav_received),
    if (rep && moves) ShellTab(7, Icons.weekend_outlined, (l) => l.nav_moves),
    if (drv) ShellTab(2, Icons.local_shipping_outlined, (l) => l.nav_trips),
    // A representative's «Отримані» already lists what drivers accepted, so only a pure driver needs this tab.
    if (drv && !rep)
      ShellTab(6, Icons.inventory_2_outlined, (l) => l.nav_accepted),
    ShellTab(3, Icons.qr_code_scanner, (l) => l.nav_scan),
    if (!queueInMore(user, moves: moves))
      ShellTab(4, Icons.cloud_upload_outlined, (l) => l.nav_queue),
    ShellTab(5, Icons.more_horiz, (l) => l.nav_more),
  ];
}
