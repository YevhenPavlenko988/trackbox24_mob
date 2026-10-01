import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/clients/data/client_api.dart';
import 'package:trackbox24_mob/features/clients/data/client_model.dart';

final _clientProvider = FutureProvider.autoDispose.family<Client, int>(
  (ref, id) => ref.watch(clientApiProvider).get(id),
);

/// Read-only client card (editing is a manager task in the web).
class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final client = ref.watch(_clientProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(client.value?.displayName ?? l.client_title)),
      body: switch (client) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            KvRow(
              l.client_type,
              value.type == ClientType.ORGANIZATION
                  ? l.client_organization
                  : l.client_privatePerson,
            ),
            KvRow(l.client_phone, formatPhone(value.phone)),
            KvRow(l.client_email, value.email),
            KvRow(l.client_city, value.city),
            KvRow(l.client_address, value.address),
            KvRow(l.client_notes, value.notes),
          ],
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(_clientProvider(id)),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
