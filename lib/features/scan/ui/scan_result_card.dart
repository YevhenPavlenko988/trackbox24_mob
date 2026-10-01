import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Overlay shown after each scan: green = done, red = rejected/failed.
class ScanResultCard extends StatelessWidget {
  const ScanResultCard({
    required this.outcome,
    required this.mode,
    this.onOpen,
    this.onDismiss,
    super.key,
  });

  final ScanOutcome outcome;
  final ScanMode mode;
  final VoidCallback? onOpen;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final (color, icon, title) = switch (outcome) {
      ScanSuccess(:final created) => (
        Colors.green.shade700,
        Icons.check_circle,
        created ? l.scan_createdNew : _successTitle(l),
      ),
      ScanFailure(:final error) => (
        scheme.error,
        Icons.error,
        describeError(context, error),
      ),
      ScanRejected(:final reason) => (
        scheme.error,
        Icons.block,
        _rejectText(l, reason),
      ),
    };
    final parcel = outcome is ScanSuccess
        ? (outcome as ScanSuccess).parcel
        : null;

    return Material(
      color: scheme.surface,
      elevation: 8,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
                if (onDismiss != null)
                  IconButton(
                    onPressed: onDismiss,
                    icon: const Icon(Icons.close),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              outcome.code,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 16),
            ),
            if (parcel != null) ...[
              const SizedBox(height: 8),
              _ParcelSummary(parcel),
              if (onOpen != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onOpen,
                    child: Text(l.scan_open),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _successTitle(AppLocalizations l) => switch (mode) {
    ScanMode.lookup => l.scan_found,
    ScanMode.receive => l.scan_received,
    ScanMode.load => l.scan_loaded,
    ScanMode.deliver => l.scan_delivered,
    ScanMode.toWarehouse => l.scan_movedToWarehouse,
  };

  String _rejectText(AppLocalizations l, ScanRejectReason r) => switch (r) {
    ScanRejectReason.notTtn => l.scan_reject_notTtn,
    ScanRejectReason.unknownCode => l.scan_reject_unknownCode,
    ScanRejectReason.tripRequired => l.scan_reject_tripRequired,
    ScanRejectReason.warehouseRequired => l.scan_reject_warehouseRequired,
  };
}

class _ParcelSummary extends StatelessWidget {
  const _ParcelSummary(this.p);

  final Parcel p;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final muted = Theme.of(context).textTheme.bodySmall;
    final loaded =
        p.seatsIn(ParcelStatus.IN_CAR) +
        p.seatsIn(ParcelStatus.DELIVERED_TO_CLIENT);
    final delivered = p.seatsIn(ParcelStatus.DELIVERED_TO_CLIENT);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ParcelStatusChip(p.status),
            if (p.needsEnrichment)
              Text(
                l.parcel_needsEnrichment,
                style: muted?.copyWith(color: Colors.orange.shade800),
              ),
            if (p.warehouseName != null) Text(p.warehouseName!, style: muted),
          ],
        ),
        const SizedBox(height: 4),
        if (p.senderName != null) Text('${l.parcel_sender}: ${p.senderName}'),
        if (p.clientName != null)
          Text(
            '${l.parcel_client}: ${p.clientName}${p.clientCity != null ? ', ${p.clientCity}' : ''}',
          ),
        if (p.description != null) Text(p.description!, style: muted),
        Text(
          p.seatCount > 1
              ? l.parcel_seatsProgress(p.seatCount, loaded, delivered)
              : l.parcel_oneSeat,
          style: muted,
        ),
      ],
    );
  }
}
