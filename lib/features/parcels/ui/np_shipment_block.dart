import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/api/api_exception.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_shipment_ui.dart';

/// Return parcels: where Nova Poshta takes the parcel after us, and our waybill.
///
/// The driver fills this in at acceptance and creates the waybill right there, so one label carries our barcode
/// and the waybill; a wrong waybill is deleted (while Nova Poshta has not taken the parcel) and created again.
/// While the waybill exists the data is frozen, and once the parcel has left us there is nothing left to edit.
class NpShipmentBlock extends ConsumerStatefulWidget {
  const NpShipmentBlock({required this.parcel, super.key});

  final Parcel parcel;

  @override
  ConsumerState<NpShipmentBlock> createState() => _NpShipmentBlockState();
}

class _NpShipmentBlockState extends ConsumerState<NpShipmentBlock> {
  bool _busy = false;

  Parcel get parcel => widget.parcel;

  void _refresh() => ref
    ..invalidate(parcelProvider(parcel.id))
    ..invalidate(parcelHistoryProvider(parcel.id));

  Future<void> _edit() async {
    await context.push<bool>('/parcels/${parcel.id}/np-shipment');
    // Saved or not, the screen may have created the waybill on its way out: reread either way.
    _refresh();
  }

  Future<void> _createWaybill() async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(parcelApiProvider).createNpWaybill(parcel.id);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.npShipment_created)));
      await context.push('/parcels/${parcel.id}/label');
    } on ApiException catch (e) {
      // A missing-field list or Nova Poshta's refusal, shown as it comes.
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _deleteWaybill() async {
    final l = AppLocalizations.of(context);
    final sure = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l.npShipment_deleteConfirmTitle),
        content: Text(l.npShipment_deleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l.npShipment_delete),
          ),
        ],
      ),
    );
    if (sure != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(parcelApiProvider).deleteNpWaybill(parcel.id);
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.npShipment_deleted)));
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeError(context, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = parcel.npShipment;
    final hasWaybill = s?.hasWaybill ?? false;
    final editable = parcel.withUs && !hasWaybill;
    if (s == null && !editable) return const SizedBox.shrink();
    // The backend lets a driver or a manager create and delete the waybill; a representative only fills it in.
    final canWaybill = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.isDriver || user.isManager,
      _ => false,
    };

    // Nova Poshta builds the waybill from the parcel itself and refuses it without these three, so the gap is
    // named here — the driver can still fix it while the person is standing in front of them.
    final missing = [
      if ((parcel.description ?? '').trim().isEmpty) l.npShipment_needDescription,
      if ((parcel.weightKg ?? 0) <= 0) l.npShipment_needWeight,
      if ((parcel.declaredValue ?? 0) <= 0) l.npShipment_needDeclaredValue,
    ];

    final actions = <Widget>[
      if (s != null && editable && canWaybill)
        FilledButton.tonalIcon(
          onPressed: _busy ? null : _createWaybill,
          icon: const Icon(Icons.local_shipping_outlined),
          label: Text(l.npShipment_create),
        ),
      if (s != null && parcel.withUs && s.waybillDeletable && canWaybill)
        OutlinedButton.icon(
          onPressed: _busy ? null : _deleteWaybill,
          icon: const Icon(Icons.delete_outline),
          label: Text(l.npShipment_delete),
        ),
      if (hasWaybill && parcel.barcode != null)
        OutlinedButton.icon(
          onPressed: () => context.push('/parcels/${parcel.id}/label'),
          icon: const Icon(Icons.print_outlined),
          label: Text(l.label_action),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle(
          l.npShipment_title,
          trailing: editable
              ? TextButton.icon(
                  onPressed: _busy ? null : _edit,
                  icon: Icon(s == null ? Icons.add : Icons.edit_outlined),
                  label: Text(s == null ? l.npShipment_fill : l.common_edit),
                )
              : null,
        ),
        if (missing.isNotEmpty && !hasWaybill)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              l.npShipment_parcelNotReady(missing.join(', ')),
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade900,
              ),
            ),
          ),
        if (s == null)
          Text(l.npShipment_empty, style: theme.textTheme.bodyMedium)
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
          // The waybill and its status exist only once it has been created.
          if (hasWaybill) ...[
            KvRow(l.npShipment_waybillNumber, s.waybillNumber),
            if (s.waybillCost != null)
              KvRow(l.npShipment_waybillCost, formatMoney(s.waybillCost)),
            KvRow(l.npShipment_shipDate, formatDate(s.shipDate)),
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
                  style: theme.textTheme.bodySmall,
                ),
              ),
          ],
        ],
        if (actions.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Wrap(spacing: 8, runSpacing: 8, children: actions),
          ),
      ],
    );
  }
}
