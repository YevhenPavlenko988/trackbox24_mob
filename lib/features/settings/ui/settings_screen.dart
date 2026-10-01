import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';

final _packageInfoProvider = FutureProvider<PackageInfo>(
  (_) => PackageInfo.fromPlatform(),
);

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
    final info = ref.watch(_packageInfoProvider).value;
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
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l.settings_version),
            subtitle: Text(
              info == null
                  ? '…'
                  : '${info.version} (${info.buildNumber}) · ${config.flavor.name}',
            ),
          ),
          if (config.isDev) ...[
            const Divider(),
            ListTile(
              leading: const Icon(Icons.dns_outlined),
              title: Text(l.settings_server),
              subtitle: Text(ref.watch(baseUrlProvider)),
              trailing: const Icon(Icons.edit_outlined),
              onTap: () => _editServer(context, ref),
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: Text(l.settings_clearQueue),
              onTap: () async {
                await ref.read(scanQueueProvider).clearAll();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.settings_clearQueueDone)),
                  );
                }
              },
            ),
          ],
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

  Future<void> _editServer(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final controller = TextEditingController(
      text: ref.read(baseUrlOverrideProvider) ?? '',
    );
    final result = await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.settings_server),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(
            hintText: ref.read(appConfigProvider).apiBaseUrl,
            helperText: l.settings_serverHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(''),
            child: Text(l.settings_serverReset),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: Text(l.common_save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    final value = result.isEmpty
        ? null
        : result.replaceFirst(RegExp(r'/+$'), '');
    await ref.read(secureStoreProvider).writeBaseUrl(value);
    ref.read(baseUrlOverrideProvider.notifier).set(value);
    // The token was issued by the previous server; start clean.
    await ref.read(authProvider.notifier).logout();
  }

  String _roleLabel(AppLocalizations l, Role r) => switch (r) {
    Role.ADMIN => l.role_ADMIN,
    Role.MANAGER => l.role_MANAGER,
    Role.REPRESENTATIVE => l.role_REPRESENTATIVE,
    Role.DRIVER => l.role_DRIVER,
    Role.VIEWER => l.role_VIEWER,
  };
}
