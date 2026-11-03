import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/core/ui/channel_ui.dart';
import 'package:trackbox24_mob/core/ui/list_card.dart';
import 'package:trackbox24_mob/core/ui/np_number.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/np_state_ui.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

/// One parcel or move in a list: code and status, who, what, Nova Poshta state and money, the trip it is in.
class ParcelTile extends ConsumerWidget {
  const ParcelTile({
    required this.parcel,
    required this.onTap,
    this.trailing,
    super.key,
  });

  final Parcel parcel;
  final VoidCallback onTap;

  /// Shortcut the list offers for this parcel, e.g. marking it received without a scan.
  final Widget? trailing;

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
    // Nova Poshta closed the waybill (returned, redirected, deleted) and we never collected it: nothing to fetch.
    final gone = atBranch && p.goneFromNp;
    final small = theme.textTheme.bodySmall;
    // the sender is often the client themself (moves): then one name
    final people = [
      ?p.senderName,
      if (p.clientName != null && p.clientName != p.senderName) p.clientName!,
    ].join(' → ');
    final moveRoute = p.isMove
        ? [
            p.senderCity,
            p.deliveryCity ?? p.clientCity,
          ].whereType<String>().where((c) => c.isNotEmpty).join(' → ')
        : '';
    final warn = Colors.orange.shade800;
    final tripColor = theme.colorScheme.primary;

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (p.channel != null && p.channel != Channel.unknown)
              Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: ChannelIcon(p.channel!, size: 18),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: NpNumberText(
                          p.code,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (p.seatCount > 1) ...[
                        const SizedBox(width: 8),
                        Text(
                          l.parcel_seatsShort(p.seatCount),
                          style: small?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                  // Our barcode is what we scan, but the waybill is how the parcel is looked up at Nova Poshta.
                  if (p.npTtn != null && p.npTtn != p.code)
                    NpNumberText(
                      p.npTtn!,
                      prefix: '${l.parcel_npTtn} ',
                      style: small?.copyWith(
                        fontFamily: 'monospace',
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ParcelStatusChip(p.status),
          ],
        ),
        if (people.isNotEmpty) CardLine(Icons.person_outline, people),
        if (p.description != null && p.description!.isNotEmpty)
          CardLine(
            p.isMove ? Icons.chair_outlined : Icons.inventory_2_outlined,
            p.description!,
          ),
        if (moveRoute.isNotEmpty) CardLine(Icons.place_outlined, moveRoute),
        if (hasQueued)
          CardLine(
            Icons.cloud_upload_outlined,
            l.parcel_queued,
            color: Colors.amber.shade900,
            style: small?.copyWith(fontWeight: FontWeight.w600),
          ),
        if (p.needsEnrichment)
          CardLine(
            Icons.edit_note,
            l.parcel_needsEnrichment,
            color: warn,
            style: small,
          ),
        // Nova Poshta: its state, what to pay at the branch, from when storage is paid
        if (p.awaitsReceiveScan && p.effectiveNpState != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: NpStateChip(p),
          ),
        if (p.awaitsReceiveScan &&
            p.npTtn != null &&
            p.effectiveNpState == null)
          CardLine(
            Icons.help_outline,
            l.np_noTracking,
            color: warn,
            style: small,
          ),
        if (p.awaitsReceiveScan && npPaymentSummary(l, p) != null)
          CardLine(
            Icons.payments_outlined,
            npPaymentSummary(l, p)!,
            style: small,
            maxLines: 2,
          ),
        if (p.awaitsReceiveScan && p.npTtn != null)
          CardLine(
            Icons.account_balance_wallet_outlined,
            '${l.np_toPay}: ${npAmountText(l, p)}',
            style: small?.copyWith(
              fontWeight: (p.npAmountToPay ?? 0) > 0 ? FontWeight.w600 : null,
            ),
          ),
        if (p.npPaidStorageFrom != null && atBranch)
          CardLine(
            Icons.warning_amber_rounded,
            '${l.parcel_paidStorageFrom}: ${formatDate(p.npPaidStorageFrom)}',
            color: storageDue ? theme.colorScheme.error : null,
            style: small?.copyWith(
              fontWeight: storageDue ? FontWeight.w600 : null,
            ),
          ),
        // Planned for a trip but not loaded yet: otherwise it looks free to plan elsewhere.
        // Loaded: the status alone does not say whose car the parcel is in.
        if (p.tripId != null || p.plannedTripId != null)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: CardTag(
              p.tripId != null
                  ? Icons.local_shipping_outlined
                  : Icons.event_note_outlined,
              p.tripId != null
                  ? l.parcel_inTrip(
                      legNo(p.tripNumber ?? p.tripId!, p.tripLegNumber),
                    )
                  : l.parcel_inTripPlan(
                      legNo(
                        p.plannedTripNumber ?? p.plannedTripId!,
                        p.tripLegNumber,
                      ),
                    ),
              color: tripColor,
            ),
          ),
      ],
    );

    return Opacity(
      // Closed at Nova Poshta (picked up / returning / deleted): nothing to go and fetch, so fade it.
      opacity: gone ? 0.55 : 1,
      child: ListCard(
        stripe: storageDue ? theme.colorScheme.error : null,
        color: storageDue
            ? Color.alphaBlend(
                theme.colorScheme.errorContainer.withValues(alpha: 0.35),
                theme.cardTheme.color ?? theme.colorScheme.surfaceContainerLow,
              )
            : null,
        onTap: onTap,
        child: trailing == null
            ? body
            : Row(
                children: [
                  Expanded(child: body),
                  trailing!,
                ],
              ),
      ),
    );
  }
}
