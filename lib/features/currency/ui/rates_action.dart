import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/app/router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';

String _short(double? v) =>
    v == null ? '—' : v.toStringAsFixed(2).replaceAll('.', ',');

/// The company's rates from the top bar of every tab («Курси валют» only): a tap shows them at a glance.
class RatesAction extends ConsumerWidget {
  const RatesAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(currencyEnabledProvider)) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    return IconButton(
      key: const ValueKey('rates-action'),
      tooltip: l.rates_title,
      icon: const Icon(Icons.currency_exchange),
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (_) => const _RatesSheet(),
      ),
    );
  }
}

class _RatesSheet extends ConsumerWidget {
  const _RatesSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rates = ref.watch(ratesProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.rates_forPayments, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ...switch (rates) {
              AsyncData(:final value) => [
                for (final r in value)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Text(
                          '1 ${currencySymbol(r.currency)}',
                          style: theme.textTheme.titleSmall,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            r.source == 'COMPANY'
                                ? l.rates_ofCompany
                                : l.rates_ofBank,
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        Text(
                          '${_short(r.rate)} грн',
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                if (value.isNotEmpty)
                  Text(
                    '${value.first.bankSourceLabel ?? '—'} · ${formatDateTime(value.first.bankAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
              AsyncError() => [Text(l.rates_unavailable)],
              _ => [const Center(child: CircularProgressIndicator())],
            },
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop();
                unawaited(context.push(Routes.rates));
              },
              child: Text(l.rates_all),
            ),
          ],
        ),
      ),
    );
  }
}
