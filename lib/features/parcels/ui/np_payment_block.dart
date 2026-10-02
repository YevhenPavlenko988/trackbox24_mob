import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';

/// What the representative pays at the Nova Poshta branch: delivery (if the recipient pays),
/// the unpaid delivery of the original waybill after a redirect, and cash on delivery.
class NpPaymentBlock extends StatelessWidget {
  const NpPaymentBlock({required this.parcel, super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = parcel;
    final theme = Theme.of(context);
    final deliveryValue = switch (p.npPayerType) {
      'Sender' => l.np_paidBySender,
      'ThirdPerson' => l.np_paidByThirdPerson,
      'Recipient' => formatMoney(p.npDeliveryCost ?? 0),
      _ => '—',
    };
    final deliveryLabel = p.npPayerType == 'Recipient'
        ? l.np_deliveryRecipient(
            p.npPaymentMethod == 'NonCash'
                ? l.np_method_NonCash
                : l.np_method_Cash,
          )
        : l.np_delivery;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l.np_amountToPayTitle, style: theme.textTheme.titleSmall),
          const SizedBox(height: 6),
          _row(theme, deliveryLabel, deliveryValue),
          if (p.npPreviousDeliveryCost != null)
            _row(
              theme,
              l.np_previousDelivery,
              formatMoney(p.npPreviousDeliveryCost),
            ),
          _row(theme, l.parcel_npCodAmount, formatMoney(p.npCodAmount ?? 0)),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l.np_total, style: theme.textTheme.titleMedium),
              Text(
                npAmountText(l, p),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: Text(label, style: theme.textTheme.bodySmall)),
        Text(value),
      ],
    ),
  );
}
