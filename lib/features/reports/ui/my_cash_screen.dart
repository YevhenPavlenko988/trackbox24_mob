import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/payment_method_ui.dart';
import 'package:trackbox24_mob/features/reports/data/reports_api.dart';

String _method(AppLocalizations l, String? method) => paymentMethodLabel(
  l,
  PaymentMethod.values.where((m) => m.name == method).firstOrNull,
);

/// «Моя каса»: what the driver (or representative) took over the days chosen, by currency and method; the cash still
/// in hand and what was handed over to the office.
class MyCashScreen extends ConsumerStatefulWidget {
  const MyCashScreen({super.key});

  @override
  ConsumerState<MyCashScreen> createState() => _MyCashScreenState();
}

class _MyCashScreenState extends ConsumerState<MyCashScreen> {
  CashPreset _preset = CashPreset.month;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final period = presetPeriod(_preset);
    final report = ref.watch(myCashProvider(period));
    final isDriver = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.isDriver,
      _ => false,
    };
    // a driver sees their pay too; a representative only the cash
    final pay = isDriver ? ref.watch(myPayProvider(period)) : null;
    return Scaffold(
      appBar: AppBar(title: Text(l.cash_title)),
      body: RefreshIndicator(
        onRefresh: () {
          if (isDriver) ref.invalidate(myPayProvider(period));
          return ref.refresh(myCashProvider(period).future);
        },
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final p in CashPreset.values)
                  ChoiceChip(
                    label: Text(switch (p) {
                      CashPreset.today => l.cash_today,
                      CashPreset.week => l.cash_week,
                      CashPreset.month => l.cash_month,
                      CashPreset.lastMonth => l.cash_lastMonth,
                    }),
                    selected: _preset == p,
                    onSelected: (_) => setState(() => _preset = p),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (pay?.value case final MyPay p) _Pay(pay: p),
            switch (report) {
              AsyncData(:final value) => _Report(report: value),
              AsyncError(:final error) => ErrorView(
                error: error,
                onRetry: () => ref.invalidate(myCashProvider(period)),
              ),
              _ => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
            },
            if (report.isLoading && report.hasValue)
              LinearProgressIndicator(color: theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }
}

class _Report extends StatelessWidget {
  const _Report({required this.report});

  final CashReport report;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final currencies = [
      for (final c in moneyCurrencies)
        if (report.totals.any((s) => s.currency == c)) c,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ----- in hand now -----
        SectionTitle(l.cash_onHand),
        Text(l.cash_onHandHint, style: muted),
        const SizedBox(height: 4),
        if (report.onHand.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.cash_onHandNone),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final h in report.onHand)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              [
                                if (h.spent > 0)
                                  l.cash_takenSpentHanded(
                                    formatMoney(h.taken, h.currency),
                                    formatMoney(h.spent, h.currency),
                                    formatMoney(h.handedOver, h.currency),
                                  )
                                else
                                  l.cash_takenHanded(
                                    formatMoney(h.taken, h.currency),
                                    formatMoney(h.handedOver, h.currency),
                                  ),
                                if (h.paidOut > 0)
                                  l.cash_keptAsPay(
                                    formatMoney(h.paidOut, h.currency),
                                  ),
                              ].join(', '),
                              style: muted,
                            ),
                          ),
                          Text(
                            formatMoney(h.onHand, h.currency),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

        // ----- taken over the days -----
        SectionTitle(l.cash_received),
        if (report.totals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l.cash_empty),
          )
        else
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final c in currencies) ...[
                    Row(
                      children: [
                        Expanded(
                          child: Text(c, style: theme.textTheme.titleSmall),
                        ),
                        Text(
                          formatMoney(
                            report.totals
                                .where((s) => s.currency == c)
                                .fold<double>(0, (n, s) => n + s.amount),
                            c,
                          ),
                          style: theme.textTheme.titleSmall,
                        ),
                      ],
                    ),
                    for (final s in report.totals.where((s) => s.currency == c))
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 2),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${_method(l, s.method)} · ${l.cash_payments(s.count)}',
                                style: muted,
                              ),
                            ),
                            Text(formatMoney(s.amount, s.currency)),
                          ],
                        ),
                      ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),

        // ----- handed over -----
        if (report.handovers.isNotEmpty) ...[
          SectionTitle(l.cash_handovers),
          for (final h in report.handovers)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.outbox_outlined),
              title: Text(formatMoney(h.amount, h.currency)),
              subtitle: Text(
                [
                  formatDateTime(h.handedAt),
                  if (h.receivedByName != null) h.receivedByName!,
                  if (h.note != null) h.note!,
                ].join(' · '),
              ),
            ),
        ],

        // ----- every payment -----
        if (report.entries.isNotEmpty) ...[
          SectionTitle('${l.cash_entries} (${report.entries.length})'),
          for (final e in report.entries)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${e.code ?? '—'} · ${formatMoney(e.amount, e.currency)}',
              ),
              subtitle: Text(
                [
                  if (e.dateOnly) formatDate(e.at) else formatDateTime(e.at),
                  _method(l, e.method),
                  if (e.clientName != null) e.clientName!,
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/parcels/${e.parcelId}'),
            ),
        ],
      ],
    );
  }
}

/// «Мій заробіток»: what is owed now, how it came about over the days, line by line.
class _Pay extends StatelessWidget {
  const _Pay({required this.pay});

  final MyPay pay;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final c = pay.currency;
    final rate = pay.rate;
    String percent(double v) => v == v.roundToDouble()
        ? v.toInt().toString()
        : v.toString().replaceAll('.', ',');
    final rateText = rate == null
        ? l.pay_noRate
        : [
            if (rate.perTrip != null)
              l.pay_perTrip(formatMoney(rate.perTrip, rate.currency)),
            if (rate.perKm != null)
              l.pay_perKm(formatMoney(rate.perKm, rate.currency)),
            if (rate.revenuePercent != null)
              l.pay_percent(percent(rate.revenuePercent!)),
            if (rate.perDay != null)
              l.pay_perDay(formatMoney(rate.perDay, rate.currency)),
            if (rate.monthly != null)
              l.pay_monthly(formatMoney(rate.monthly, rate.currency)),
          ].join(' · ');
    Widget row(String label, double value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: muted)),
          Text(formatMoney(value, c)),
        ],
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(l.pay_title),
        Text(rateText, style: muted),
        const SizedBox(height: 4),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        pay.closing < 0 ? l.pay_overpaid : l.pay_owed,
                        style: theme.textTheme.titleSmall,
                      ),
                    ),
                    Text(
                      formatMoney(pay.closing.abs(), c),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                // zero alone reads as nothing earned: say why it is zero
                if (pay.closing == 0 && (pay.accrued != 0 || pay.paid != 0))
                  Text(l.pay_allPaid, style: muted),
                const SizedBox(height: 8),
                if (pay.opening != 0) row(l.pay_opening, pay.opening),
                row(l.pay_accrued, pay.accrued),
                if (pay.expenses != 0) row(l.pay_expenses, pay.expenses),
                row(l.pay_paid, pay.paid),
              ],
            ),
          ),
        ),
        for (final line in pay.lines)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            title: Text(switch (line.kind) {
              'TRIP' => l.pay_trip(line.tripNumber ?? '—'),
              'MONTHLY' => l.pay_monthlyLine(
                line.days ?? 0,
                line.monthDays ?? 0,
              ),
              'EXPENSE' => l.pay_expenseLine(line.tripNumber ?? '—'),
              _ => l.pay_payout,
            }),
            subtitle: Text(
              [
                formatDate(line.date),
                if (line.kind == 'TRIP' && line.noRate) l.pay_tripNoRate,
                if (line.kind == 'TRIP' && !line.noRate && line.days != null)
                  l.pay_tripDays(line.days!),
                if (line.kind == 'TRIP' && line.km != null) '${line.km} км',
                if (line.fromCollectedCash) l.pay_fromCash,
                if (line.kind != 'TRIP' && line.label != null) line.label!,
              ].join(' · '),
            ),
            trailing: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatMoney(line.balanceAmount, c),
                  style: TextStyle(
                    color: line.balanceAmount < 0
                        ? theme.colorScheme.error
                        : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // entered in another currency: as it was entered
                if (line.currency != c && line.amount != 0)
                  Text(formatMoney(line.amount, line.currency), style: muted),
              ],
            ),
          ),
      ],
    );
  }
}
