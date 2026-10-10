import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/channel_ui.dart';
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
            if (value.channel != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ChannelLine(
                  channel: value.channel!,
                  details: value.channelDetails,
                ),
              ),
            KvRow(l.client_notes, value.notes),
            // What the client's parcels add up to; the backend sends nothing of this to a representative.
            if (value.money.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                l.client_money,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              for (final m in value.money) _MoneyBlock(money: m),
            ],
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

/// Four figures for one currency; a debt is what the driver has to ask about, so it stands out.
class _MoneyBlock extends StatelessWidget {
  const _MoneyBlock({required this.money});

  final ClientMoney money;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final m = money;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          KvRow(l.client_moneyTotal, formatMoney(m.total, m.currency)),
          KvRow(l.client_moneyPaid, formatMoney(m.paid, m.currency)),
          _DebtRow(amount: m.debt, currency: m.currency),
          KvRow(l.client_moneyUpcoming, formatMoney(m.upcoming, m.currency)),
        ],
      ),
    );
  }
}

class _DebtRow extends StatelessWidget {
  const _DebtRow({required this.amount, required this.currency});

  final double amount;
  final String? currency;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final owing = amount > 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              l.client_moneyDebt,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              formatMoney(amount, currency),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: owing ? Colors.orange.shade900 : null,
                fontWeight: owing ? FontWeight.w700 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
