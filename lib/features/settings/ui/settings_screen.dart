import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final config = ref.watch(appConfigProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.settings_title)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(user?.displayName ?? '—'),
            subtitle: Text(user?.email ?? ''),
          ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text(l.settings_roles),
            subtitle: Text(
              user?.roles.map((r) => _roleLabel(l, r)).join(', ') ?? '—',
            ),
          ),
          if (config.isDev)
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l.settings_server),
              subtitle: Text(ref.watch(baseUrlProvider)),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l.auth_logout),
            onTap: () => ref.read(authProvider.notifier).logout(),
          ),
        ],
      ),
    );
  }

  String _roleLabel(AppLocalizations l, Role r) => switch (r) {
    Role.ADMIN => l.role_ADMIN,
    Role.MANAGER => l.role_MANAGER,
    Role.REPRESENTATIVE => l.role_REPRESENTATIVE,
    Role.DRIVER => l.role_DRIVER,
    Role.VIEWER => l.role_VIEWER,
  };
}
