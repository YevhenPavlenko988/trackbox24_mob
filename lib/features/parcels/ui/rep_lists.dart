import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_list.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_list_screen.dart';

/// Parcels still at Nova Poshta, soonest paid storage first.
class ToReceiveScreen extends StatelessWidget {
  const ToReceiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ParcelListScreen(
      title: l.screen_toReceive,
      emptyText: l.parcels_toReceiveEmpty,
      showCreate: true,
      // Nova Poshta's own status decides what is actually waiting at the branch; the backend cannot filter by it yet.
      filters: [
        ParcelListFilter(label: (l) => l.npFilter_all, test: (_) => true),
        ParcelListFilter(
          label: (l) => l.npFilter_arrived,
          test: (p) => p.effectiveNpState == NpState.ARRIVED,
        ),
        ParcelListFilter(
          label: (l) => l.npFilter_transit,
          test: (p) =>
              p.effectiveNpState == null ||
              (!p.goneFromNp && p.effectiveNpState != NpState.ARRIVED),
        ),
        ParcelListFilter(
          label: (l) => l.npFilter_gone,
          test: (p) => p.goneFromNp,
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

/// Parcels the current representative has picked up and not yet handed over.
class ReceivedScreen extends ConsumerWidget {
  const ReceivedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.id,
      _ => null,
    };
    return ParcelListScreen(
      title: l.nav_received,
      emptyText: l.parcels_receivedEmpty,
      keyFor: (q) => ParcelListKey(
        status: ParcelStatus.RECEIVED_BY_REPRESENTATIVE,
        representativeId: me,
        sort: 'statusChangedAt,desc',
        query: q,
      ),
    );
  }
}
