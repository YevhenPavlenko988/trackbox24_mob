import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';

/// «45,66», «11,7324», «46,50»: up to four decimals, at least two.
String _rate(double? v) {
  if (v == null) return '—';
  var s = v.toStringAsFixed(4);
  while (s.endsWith('0') && s.indexOf('.') < s.length - 3) {
    s = s.substring(0, s.length - 1);
  }
  return s.replaceAll('.', ',');
}

/// «Курси валют»: the bank's commercial rate and the company's own. A representative sets the company's rate;
/// a driver only sees what payments are counted at.
class RatesScreen extends ConsumerWidget {
  const RatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final canEdit =
        (user?.isManager ?? false) || (user?.isRepresentative ?? false);
    final rates = ref.watch(ratesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.rates_title)),
      body: switch (rates) {
        AsyncData(:final value) => RefreshIndicator(
          onRefresh: () => ref.refresh(ratesProvider.future),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l.rates_hint, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              for (final r in value) _RateCard(rate: r, canEdit: canEdit),
            ],
          ),
        ),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(ratesProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _RateCard extends ConsumerWidget {
  const _RateCard({required this.rate, required this.canEdit});

  final CurrencyRate rate;
  final bool canEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final own = rate.source == 'COMPANY';
    Future<void> act(Future<void> Function(CurrencyApi api) fn) async {
      try {
        await fn(ref.read(currencyApiProvider));
        ref.invalidate(ratesProvider);
      } on ApiException catch (e) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(describeError(context, e))));
      }
    }

    return Card(
      key: ValueKey('rate-${rate.currency}'),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1 ${currencySymbol(rate.currency)} = ${_rate(rate.rate)} грн',
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    own
                        ? l.rates_company(
                            rate.companySetBy ?? '—',
                            formatDateTime(rate.companySetAt),
                          )
                        : l.rates_bankUsed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: own ? theme.colorScheme.primary : null,
                    ),
                  ),
                  Text(
                    l.rates_bank(
                      rate.bankSourceLabel ?? '—',
                      _rate(rate.bankBuy),
                      _rate(rate.bankSell),
                      formatDateTime(rate.bankAt),
                    ),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (canEdit) ...[
              IconButton(
                tooltip: l.rates_set,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () async {
                  final v = await _ask(context, l, rate);
                  if (v != null) {
                    await act((api) => api.setRate(rate.currency, v));
                  }
                },
              ),
              if (own)
                IconButton(
                  tooltip: l.rates_reset,
                  icon: const Icon(Icons.undo),
                  onPressed: () => act((api) => api.resetRate(rate.currency)),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Future<double?> _ask(
    BuildContext context,
    AppLocalizations l,
    CurrencyRate r,
  ) {
    final c = TextEditingController(
      text: _rate(r.companyRate ?? r.rate).replaceAll('—', ''),
    );
    return showDialog<double>(
      context: context,
      builder: (ctx) {
        void done() {
          final v = double.tryParse(c.text.trim().replaceAll(',', '.'));
          if (v != null && v > 0) Navigator.of(ctx).pop(v);
        }

        return AlertDialog(
          title: Text(l.rates_setTitle(currencySymbol(r.currency))),
          content: TextField(
            controller: c,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              suffixText: 'грн',
              helperText: l.rates_setHelp,
            ),
            onSubmitted: (_) => done(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l.common_cancel),
            ),
            FilledButton(onPressed: done, child: Text(l.common_save)),
          ],
        );
      },
    );
  }
}
