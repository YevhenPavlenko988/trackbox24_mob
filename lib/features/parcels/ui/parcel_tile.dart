import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/core/ui/channel_ui.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';

/// One parcel in a list: code, status, sender/client, seats, paid-storage warning.
class ParcelTile extends ConsumerWidget {
  const ParcelTile({required this.parcel, required this.onTap, super.key});

  final Parcel parcel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = parcel;
    final queued = ref.watch(queuedCodesProvider).value ?? const <String>{};
    final hasQueued =
        queued.contains(p.barcode) ||
        queued.contains(p.npTtn) ||
        p.seats.any((s) => queued.contains(s.barcode));
    // Storage is only charged while the parcel still sits at the branch.
    final atBranch = p.status == ParcelStatus.IN_NOVA_POSHTA;
    final storageDue = atBranch && p.paidStorageDue;
    final subtitle = [
      if (p.senderName != null) '${l.parcel_sender}: ${p.senderName}',
      if (p.clientName != null) '${l.parcel_client}: ${p.clientName}',
      if (p.description != null && p.description!.isNotEmpty) p.description!,
    ].join('\n');

    // Nova Poshta closed the waybill (returned, redirected, deleted) and we never collected it: nothing to fetch.
    final gone = atBranch && p.goneFromNp;

    return ListTile(
      onTap: onTap,
      // Closed at Nova Poshta (picked up / returning / deleted): nothing to go and fetch, so fade it.
      textColor: gone ? theme.disabledColor : null,
      tileColor: storageDue
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.35)
          : null,
      title: Row(
        children: [
          if (p.channel != null && p.channel != Channel.unknown)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: ChannelIcon(p.channel!, size: 18),
            ),
          Expanded(
            child: Text(
              p.code,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (p.seatCount > 1)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                l.parcel_seatsShort(p.seatCount),
                style: theme.textTheme.bodySmall,
              ),
            ),
          ParcelStatusChip(p.status),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (subtitle.isNotEmpty)
            Text(subtitle, maxLines: 3, overflow: TextOverflow.ellipsis),
          if (hasQueued)
            Text(
              l.parcel_queued,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.amber.shade900,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (p.needsEnrichment)
            Text(
              l.parcel_needsEnrichment,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
              ),
            ),
          if (p.awaitsReceiveScan && p.effectiveNpState != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [NpStateChip(p)],
              ),
            ),
          if (p.awaitsReceiveScan &&
              p.npTtn != null &&
              p.effectiveNpState == null)
            Text(
              l.np_noTracking,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
              ),
            ),
          if (p.awaitsReceiveScan && npPaymentSummary(l, p) != null)
            Text(npPaymentSummary(l, p)!, style: theme.textTheme.bodySmall),
          if (p.awaitsReceiveScan && p.npTtn != null)
            Text(
              '${l.np_toPay}: ${npAmountText(l, p)}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: (p.npAmountToPay ?? 0) > 0 ? FontWeight.w600 : null,
              ),
            ),
          if (p.npPaidStorageFrom != null && atBranch)
            Text(
              '${l.parcel_paidStorageFrom}: ${formatDate(p.npPaidStorageFrom)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: storageDue ? theme.colorScheme.error : null,
                fontWeight: storageDue ? FontWeight.w600 : null,
              ),
            ),
        ],
      ),
      isThreeLine: subtitle.contains('\n') || p.needsEnrichment,
    );
  }
}
