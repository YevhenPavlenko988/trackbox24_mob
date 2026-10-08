import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_list.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_list_screen.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// Parcels still at Nova Poshta, soonest paid storage first.
class ToReceiveScreen extends ConsumerWidget {
  const ToReceiveScreen({super.key});

  /// Marking a parcel received by hand is the same scan the camera would make, so it goes through ScanService
  /// (and its offline queue). Asked for confirmation because nothing was actually scanned.
  Future<void> _receiveByHand(
    BuildContext context,
    WidgetRef ref,
    Parcel parcel,
  ) async {
    final l = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l.receiveWithoutScan_title),
        content: Text(l.receiveWithoutScan_body(parcel.code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l.common_cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l.receiveWithoutScan_confirm),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final outcome = await ref
        .read(scanServiceProvider)
        .perform(ScanMode.receive, parcel.npTtn!, manual: true);
    if (!context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    switch (outcome) {
      case ScanSuccess(:final parcel):
        messenger.showSnackBar(
          SnackBar(content: Text(l.receiveWithoutScan_done(parcel.code))),
        );
        // The parcel has left this list for «Отримані», so both have to be re-read.
        ref.invalidate(parcelListProvider);
        unawaited(ref.read(scanQueueWorkerProvider).run());
      case ScanQueued():
        messenger.showSnackBar(SnackBar(content: Text(l.scan_queued)));
      case ScanFailure(:final error):
        messenger.showSnackBar(
          SnackBar(content: Text(describeError(context, error))),
        );
      case ScanRejected():
        messenger.showSnackBar(
          SnackBar(content: Text(l.scan_reject_unknownCode)),
        );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final canReceive =
        user?.isRepresentative == true || user?.isManager == true;

    return ParcelListScreen(
      // Only for a parcel Nova Poshta has already handed over («У нас»): there is nothing left to collect at the
      // branch, so the representative just confirms it. One still at the branch is received by scanning it there.
      trailingFor: (p) =>
          canReceive &&
              p.npTtn != null &&
              p.status == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA
          ? IconButton(
              icon: const Icon(Icons.check_circle_outline),
              tooltip: l.receiveWithoutScan_action,
              onPressed: () => _receiveByHand(context, ref, p),
            )
          : null,
      title: l.screen_toReceive,
      emptyText: l.parcels_toReceiveEmpty,
      showCreate: true,
      // Where the parcel is from the representative's point of view: collect it, wait for it, scan it, or sort it out.
      filters: [
        ParcelListFilter(label: (l) => l.npFilter_all, test: (_) => true),
        ParcelListFilter(
          label: (l) => l.npFilter_arrived,
          test: (p) =>
              p.status == ParcelStatus.IN_NOVA_POSHTA &&
              p.effectiveNpState == NpState.ARRIVED,
        ),
        ParcelListFilter(
          label: (l) => l.npFilter_transit,
          test: (p) =>
              p.status == ParcelStatus.IN_NOVA_POSHTA &&
              !p.npProblem &&
              p.effectiveNpState != NpState.ARRIVED,
        ),
        ParcelListFilter(
          label: (l) => l.npFilter_withUs,
          test: (p) => p.status == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA,
        ),
        ParcelListFilter(
          label: (l) => l.npFilter_problem,
          test: (p) => p.npProblem,
        ),
      ],
      keyFor: (q) => const ParcelListKey(
        statuses: [
          ParcelStatus.IN_NOVA_POSHTA,
          ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA,
        ],
        sort: paidStorageSort,
      ).copyWith(query: q),
    );
  }
}

/// Parcels the company has collected and not yet handed over, whoever picked them up.
class ReceivedScreen extends StatelessWidget {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ParcelListScreen(
      title: l.nav_received,
      emptyText: l.parcels_receivedEmpty,
      keyFor: (q) => ParcelListKey(
        status: ParcelStatus.RECEIVED_BY_REPRESENTATIVE,
        sort: 'statusChangedAt,desc',
        query: q,
      ),
    );
  }
}
