import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';

String _rate(double k) => k.toStringAsFixed(4).replaceAll('.', ',');

double _round(double v) => (v * 100).round() / 100;

/// The price in the other currencies at the company's rates now: «≈ 1 552,79 грн · 33,71 $ · 132,51 zł»
/// («Курси валют» only; nothing otherwise).
class PriceInCurrencies extends ConsumerWidget {
  const PriceInCurrencies({
    required this.price,
    required this.currency,
    super.key,
  });

  final double price;
  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(currencyEnabledProvider)) return const SizedBox.shrink();
    final rates = ref.watch(ratesProvider).value;
    final parts = [
      for (final c in moneyCurrencies.where((c) => c != currency))
        if (convertRate(rates, currency, c) case final k?)
          formatMoney(_round(price * k), c),
    ];
    if (parts.isEmpty) return const SizedBox.shrink();
    return Text(
      '≈ ${parts.join(' · ')}',
      key: const ValueKey('price-in-currencies'),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

/// Which currency the client pays in, with what it comes to («Курси валют» only).
class PaidCurrencyPicker extends ConsumerWidget {
  const PaidCurrencyPicker({
    required this.price,
    required this.priceCurrency,
    required this.method,
    required this.value,
    required this.onChanged,
    super.key,
  });

  final double price;
  final String priceCurrency;
  final String? method;
  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(currencyEnabledProvider)) return const SizedBox.shrink();
    final l = AppLocalizations.of(context);
    final ratesAsync = ref.watch(ratesProvider);
    final rates = ratesAsync.value;
    final k = convertRate(rates, priceCurrency, value);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(l.parcel_paidIn, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        // each currency with what the price comes to in it: choosing the currency is choosing the sum
        Wrap(
          key: const ValueKey('paid-currency'),
          spacing: 6,
          runSpacing: 6,
          children: [
            for (final c in paidCurrencies(method))
              // without a rate (the banks did not answer, no company rate) the currency is shown but cannot be picked
              switch (convertRate(rates, priceCurrency, c)) {
                final r? => ChoiceChip(
                  key: ValueKey('paid-$c'),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  showCheckmark: false,
                  label: Text(formatMoney(_round(price * r), c)),
                  selected: value == c,
                  onSelected: (_) => onChanged(c),
                ),
                null => ChoiceChip(
                  key: ValueKey('paid-$c'),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  label: Text(currencySymbol(c)),
                  // no onSelected: disabled
                  selected: false,
                ),
              },
          ],
        ),
        // no rate yet: the banks did not answer and the company has none of its own
        if (ratesAsync.hasError ||
            (rates != null &&
                paidCurrencies(method)
                    .any((c) => convertRate(rates, priceCurrency, c) == null)))
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(l.bill_noRate, style: theme.textTheme.bodySmall),
          ),
        if (value != priceCurrency)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              k == null
                  ? l.bill_noRate
                  : l.scan_paidAtRate(
                      '1 ${currencySymbol(priceCurrency)} = ${_rate(k)} ${currencySymbol(value)}',
                    ),
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

/// «1 552,79 грн за курсом 1 € = 51,7598 грн» for a parcel paid in another currency.
String? paidInLine(
  String? paidCurrency,
  double? paidAmount,
  double? paidRate,
  String? priceCurrency,
) => paidCurrency == null || paidRate == null
    ? null
    : '${formatMoney(paidAmount, paidCurrency)} за курсом 1 ${currencySymbol(priceCurrency)} = ${_rate(paidRate)} ${currencySymbol(paidCurrency)}';
