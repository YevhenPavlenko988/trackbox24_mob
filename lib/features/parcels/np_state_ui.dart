import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

String npStateLabel(AppLocalizations l, Parcel p) =>
    switch (p.effectiveNpState) {
      NpState.CREATED => l.npState_CREATED,
      NpState.IN_TRANSIT => l.npState_IN_TRANSIT,
      NpState.ARRIVED => l.npState_ARRIVED,
      NpState.RECEIVED => l.npState_RECEIVED,
      NpState.REDIRECTED => l.npState_REDIRECTED,
      NpState.RETURNING => l.npState_RETURNING,
      NpState.DELIVERY_FAILED => l.npState_DELIVERY_FAILED,
      NpState.NOT_FOUND => l.npState_NOT_FOUND,
      _ => p.npStatusText ?? l.npState_OTHER,
    };

Color npStateColor(NpState? s) => switch (s) {
  NpState.IN_TRANSIT => Colors.lightBlue.shade800,
  NpState.ARRIVED => Colors.green.shade700,
  NpState.RECEIVED => Colors.green.shade900,
  NpState.REDIRECTED => Colors.orange.shade800,
  NpState.RETURNING || NpState.DELIVERY_FAILED => Colors.red.shade700,
  NpState.NOT_FOUND => Colors.grey.shade600,
  _ => Colors.blueGrey.shade600,
};

/// "НП · У відділенні" — what Nova Poshta says, shown next to our own status.
class NpStateChip extends StatelessWidget {
  const NpStateChip(this.parcel, {super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context) {
    final state = parcel.effectiveNpState;
    if (state == null) return const SizedBox.shrink();
    final color = npStateColor(state);
    return Tooltip(
      message: parcel.npStatusText ?? '',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          'НП · ${npStateLabel(AppLocalizations.of(context), parcel)}',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Amount to pay at the branch, or "невідомо" when the backend has not computed it yet (never 0 by default).
String npAmountText(AppLocalizations l, Parcel p) =>
    p.npAmountToPay == null ? l.np_unknown : formatMoney(p.npAmountToPay);

String? npPayerLabel(AppLocalizations l, String? type) => switch (type) {
  'Sender' => l.np_payer_Sender,
  'Recipient' => l.np_payer_Recipient,
  'ThirdPerson' => l.np_payer_ThirdPerson,
  _ => type,
};

String? npMethodLabel(AppLocalizations l, String? m) => switch (m) {
  'Cash' => l.np_method_Cash,
  'NonCash' => l.np_method_NonCash,
  _ => m,
};

/// One line for lists: "Доставка НП: 173 грн · оплачено відправником" / "· платить отримувач, готівка".
String? npPaymentSummary(AppLocalizations l, Parcel p) {
  if (p.npTtn == null) return null;
  final cost = p.npDeliveryCost;
  final who = switch (p.npPayerType) {
    'Sender' => l.np_paidBySender,
    'ThirdPerson' => l.np_paidByThirdPerson,
    'Recipient' =>
      '${l.np_recipientPays}${p.npPaymentMethod != null ? ', ${npMethodLabel(l, p.npPaymentMethod)}' : ''}',
    _ => null,
  };
  if (cost == null && who == null) return null;
  return [
    '${l.parcel_npDeliveryCost}: ${cost == null ? l.np_unknown : formatMoney(cost)}',
    if (who != null) who,
  ].join(' · ');
}
