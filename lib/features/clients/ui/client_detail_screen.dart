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
              _MoneyBlock(money: value.money),
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

/// What the client brought in since the beginning, kept apart from what is outstanding right now:
/// in one row they read as a single total, which they are not.
class _MoneyBlock extends StatelessWidget {
  const _MoneyBlock({required this.money});

  final List<ClientMoney> money;

  /// Only the currencies that have something; a zero in every currency says nothing.
  List<String> _amounts(double Function(ClientMoney) pick) => [
    for (final m in money)
      if (pick(m) > 0) formatMoney(pick(m), m.currency),
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Figure(
          label: l.client_moneyEarned,
          hint: l.client_moneyEarnedHint,
          amounts: _amounts((m) => m.paid),
        ),
        const Divider(height: 24),
        _Figure(
          label: l.client_moneyDebt,
          hint: l.client_moneyDebtHint,
          amounts: _amounts((m) => m.debt),
          alarming: true,
        ),
        const SizedBox(height: 12),
        _Figure(
          label: l.client_moneyUpcoming,
          hint: l.client_moneyUpcomingHint,
          amounts: _amounts((m) => m.upcoming),
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({
    required this.label,
    required this.hint,
    required this.amounts,
    this.alarming = false,
  });

  final String label;
  final String hint;
  final List<String> amounts;

  /// Highlighted only when there is actually something to chase.
  final bool alarming;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final loud = alarming && amounts.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          amounts.isEmpty ? l.client_moneyNone : amounts.join(' · '),
          style: theme.textTheme.titleMedium?.copyWith(
            color: loud ? Colors.orange.shade900 : null,
            fontWeight: loud ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        Text(
          hint,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
