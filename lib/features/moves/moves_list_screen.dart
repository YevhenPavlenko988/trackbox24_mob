import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/state/parcel_list.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_list_screen.dart';

/// Every move of the company, newest first. Opens on the ones still in work: those are what a representative is on site for.
class MovesListScreen extends StatelessWidget {
  const MovesListScreen({super.key});

  static const _inWork = [
    ParcelStatus.RECEIVED_BY_REPRESENTATIVE,
    ParcelStatus.ACCEPTED_BY_DRIVER,
    ParcelStatus.AT_WAREHOUSE,
    ParcelStatus.IN_CAR,
  ];

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return ParcelListScreen(
      title: l.nav_moves,
      emptyText: l.moves_empty,
      showCreate: true,
      filters: [
        ParcelListFilter(
          label: (l) => l.movesFilter_inWork,
          adjust: (k) => k.copyWith(statuses: _inWork),
        ),
        ParcelListFilter(
          label: (l) => l.movesFilter_delivered,
          adjust: (k) =>
              k.copyWith(statuses: const [ParcelStatus.DELIVERED_TO_CLIENT]),
        ),
        ParcelListFilter(label: (l) => l.acceptedFilter_all),
      ],
      keyFor: (q) =>
          ParcelListKey(kind: 'MOVE', sort: 'createdAt,desc', query: q),
    );
  }
}
