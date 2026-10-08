import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/scan/state/scan_actions.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

/// What the user picked in the sheet: the action plus the context it needed.
class ChosenScanAction {
  const ChosenScanAction(
    this.mode, {
    this.tripId,
    this.warehouse,
    this.paymentReceived = false,
  });

  final ScanMode mode;
  final int? tripId;

  /// Kept whole so the next scan can show its name without asking again.
  final Warehouse? warehouse;
  final bool paymentReceived;

  int? get warehouseId => warehouse?.id;
}

/// Shows the scanned parcel and the actions its status allows; returns the one the user picked.
class ScanActionSheet extends ConsumerStatefulWidget {
  const ScanActionSheet({
    required this.code,
    required this.actions,
    required this.onPickTrip,
    this.parcel,
    this.lookupError,
    this.tripId,
    this.warehouse,
    super.key,
  });

  final String code;
  final List<ScanAction> actions;

  /// Null when the lookup could not reach the backend; then [lookupError] says why.
  final Parcel? parcel;
  final Object? lookupError;

  /// Remembered between scans so a run of parcels does not ask every time.
  final int? tripId;
  final Warehouse? warehouse;
  final Future<int?> Function() onPickTrip;

  @override
  ConsumerState<ScanActionSheet> createState() => _ScanActionSheetState();
}

class _ScanActionSheetState extends ConsumerState<ScanActionSheet> {
  late int? _tripId = widget.tripId;
  late Warehouse? _warehouse = widget.warehouse;
  bool _paymentReceived = false;

  Future<void> _run(ScanAction action) async {
    if (action.needsTrip && _tripId == null) {
      final picked = await widget.onPickTrip();
      if (picked == null) return;
      if (!mounted) return;
      setState(() => _tripId = picked);
    }
    if (action.needsWarehouse && _warehouse == null) {
      final picked = await _pickWarehouse();
      if (picked == null) return;
      if (!mounted) return;
      setState(() => _warehouse = picked);
    }
    if (!mounted) return;
    Navigator.of(context).pop(
      ChosenScanAction(
        action.mode,
        tripId: _tripId,
        warehouse: _warehouse,
        paymentReceived: _paymentReceived,
      ),
    );
  }

  Future<Warehouse?> _pickWarehouse() async {
    final warehouses = await ref.read(activeWarehousesProvider.future);
    if (!mounted) return null;
    return await showModalBottomSheet<Warehouse>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final w in warehouses)
              ListTile(
                leading: const Icon(Icons.warehouse_outlined),
                title: Text(w.name),
                subtitle: w.address == null ? null : Text(w.address!),
                onTap: () => Navigator.of(context).pop(w),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = widget.parcel;
    final canDeliver = widget.actions.any((a) => a.mode == ScanMode.deliver);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              p?.code ?? widget.code,
              style: theme.textTheme.titleLarge?.copyWith(
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 8),
            if (p != null) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ParcelStatusChip(p.status),
                  if (p.awaitsReceiveScan && p.effectiveNpState != null)
                    NpStateChip(p),
                  if (p.warehouseName != null)
                    Text(p.warehouseName!, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              if (p.clientName != null)
                Text(
                  '${l.parcel_client}: ${p.clientName}',
                  style: theme.textTheme.bodyMedium,
                ),
              if (p.senderName != null)
                Text(
                  '${l.parcel_sender}: ${p.senderName}',
                  style: theme.textTheme.bodySmall,
                ),
              if (p.awaitsReceiveScan && p.npTtn != null)
                Text(
                  '${l.np_toPay}: ${npAmountText(l, p)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (p.hasPrice)
                Text(
                  '${l.parcel_deliveryPrice}: ${formatMoney(p.deliveryPrice, p.deliveryPriceCurrency)}'
                  '${p.isPaid ? ' · ${l.parcel_paid}' : ''}',
                  style: theme.textTheme.bodySmall,
                ),
            ] else
              Text(
                widget.lookupError == null
                    ? l.scanAction_offline
                    : '${describeError(context, widget.lookupError!)}\n${l.scanAction_offline}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.orange.shade900,
                ),
              ),

            const SizedBox(height: 16),
            if (widget.actions.isEmpty)
              Text(l.scanAction_none, style: theme.textTheme.bodyMedium)
            else ...[
              // Paying at hand-over is part of the deliver action, so the switch sits with it.
              if (canDeliver && (p?.hasPrice ?? true))
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  secondary: const Icon(Icons.payments_outlined),
                  title: Text(l.scan_paymentReceived),
                  value: _paymentReceived,
                  onChanged: (v) => setState(() => _paymentReceived = v),
                ),
              for (final action in widget.actions) ...[
                FilledButton.icon(
                  onPressed: () => _run(action),
                  icon: Icon(action.icon),
                  label: Text(_labelWithContext(l, action)),
                ),
                const SizedBox(height: 8),
              ],
            ],
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l.scanAction_pickAgain),
            ),
          ],
        ),
      ),
    );
  }

  /// The button says where the parcel is going when that is already known.
  String _labelWithContext(AppLocalizations l, ScanAction action) {
    final base = action.label(l);
    if (action.needsTrip && _tripId != null) {
      return '$base · ${l.scan_tripSelected(_tripId!)}';
    }
    if (action.needsWarehouse && _warehouse != null) {
      return '$base · ${_warehouse!.name}';
    }
    return base;
  }
}
