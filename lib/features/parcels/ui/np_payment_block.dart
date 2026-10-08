import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';

/// Nova Poshta says the delivery is already paid (online, before pickup).
bool npDeliveryPaid(Parcel p) => p.npPaymentStatus == 'Payed';

/// What the representative pays at the Nova Poshta branch. The parts come from the backend and always add up to
/// the total, so nothing is recomputed here.
class NpPaymentBlock extends StatelessWidget {
  const NpPaymentBlock({required this.parcel, super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final p = parcel;
    final theme = Theme.of(context);
    final deliveryValue = p.npDeliveryToPay != null
        ? formatMoney(p.npDeliveryToPay)
        : '—';
    // A zero says nothing on its own, so the reason goes next to the label.
    final deliveryNote = npDeliveryPaid(p)
        ? l.np_paidOnline
        : switch (p.npPayerType) {
            'Sender' => l.np_paidBySender,
            'ThirdPerson' => l.np_paidByThirdPerson,
            _ => null,
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
          _row(theme, deliveryLabel, deliveryValue, note: deliveryNote),
          if (p.npPreviousDeliveryToPay != null)
            _row(
              theme,
              l.np_previousDelivery,
              formatMoney(p.npPreviousDeliveryToPay),
            ),
          _row(theme, l.parcel_npCodAmount, formatMoney(p.npCodToPay ?? 0)),
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
          if (p.npState == NpState.RECEIVED)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(l.np_settled, style: theme.textTheme.bodySmall),
            ),
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value, {String? note}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                note == null ? label : '$label · $note',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Text(value),
          ],
        ),
      );
}
