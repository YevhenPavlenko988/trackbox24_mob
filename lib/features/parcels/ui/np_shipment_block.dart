import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_shipment_ui.dart';

/// Return parcels: where Nova Poshta takes the parcel after us, and our waybill once a manager creates it.
///
/// The driver fills this in at acceptance; after the waybill exists the data is frozen until it is deleted
/// (in the web back-office), and once the parcel has left us there is nothing left to edit.
class NpShipmentBlock extends ConsumerWidget {
  const NpShipmentBlock({required this.parcel, super.key});

  final Parcel parcel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final s = parcel.npShipment;
    final editable = parcel.withUs && !(s?.hasWaybill ?? false);
    if (s == null && !editable) return const SizedBox.shrink();

    Future<void> edit() async {
      final saved = await context.push<bool>('/parcels/${parcel.id}/np-shipment');
      if (saved ?? false) ref.invalidate(parcelProvider(parcel.id));
    }

    // Nova Poshta builds the waybill from the parcel itself and refuses it without these three, so the gap is
    // named here — the driver can still fix it while the person is standing in front of them.
    final missing = [
      if ((parcel.description ?? '').trim().isEmpty) l.npShipment_needDescription,
      if ((parcel.weightKg ?? 0) <= 0) l.npShipment_needWeight,
      if ((parcel.declaredValue ?? 0) <= 0) l.npShipment_needDeclaredValue,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          l.npShipment_title,
          trailing: editable
              ? TextButton.icon(
                  onPressed: edit,
                  icon: Icon(s == null ? Icons.add : Icons.edit_outlined),
                  label: Text(s == null ? l.npShipment_fill : l.common_edit),
                )
              : null,
        ),
        if (missing.isNotEmpty && !(s?.hasWaybill ?? false))
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              l.npShipment_parcelNotReady(missing.join(', ')),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade900,
              ),
            ),
          ),
        if (s == null)
          Text(l.npShipment_empty, style: Theme.of(context).textTheme.bodyMedium)
        else ...[
          KvRow(l.npShipment_recipient, s.recipientName),
          KvRow(l.npShipment_phone, formatPhone(s.recipientPhone)),
          KvRow(l.npShipment_deliveryType, npDeliveryTypeLabel(l, s.deliveryType)),
          KvRow(l.npShipment_destination, s.destination),
          KvRow(l.npShipment_cargoType, npCargoTypeLabel(l, s.cargoType)),
          KvRow(l.npShipment_payerType, npPayerTypeLabel(l, s.payerType)),
          KvRow(l.npShipment_paymentMethod, npPaymentMethodLabel(l, s.paymentMethod)),
          if ((s.codAmount ?? 0) > 0)
            KvRow(l.npShipment_codAmount, formatMoney(s.codAmount)),
          // The waybill and its status exist only after a manager has created it.
          if (s.hasWaybill) ...[
            KvRow(l.npShipment_waybillNumber, s.waybillNumber),
            if (s.waybillCost != null)
              KvRow(l.npShipment_waybillCost, formatMoney(s.waybillCost)),
            KvRow(
              l.npShipment_estimatedDeliveryDate,
              formatDate(s.estimatedDeliveryDate),
            ),
            KvRow(
              l.npShipment_npStatus,
              s.npStatusText == null
                  ? null
                  : '${s.npStatusText}${s.npStatusCode != null ? ' (${s.npStatusCode})' : ''}',
            ),
            KvRow(
              l.npShipment_npStatusUpdatedAt,
              formatDateTime(s.npStatusUpdatedAt),
            ),
            if (parcel.withUs)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l.npShipment_locked,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ],
      ],
    );
  }
}
