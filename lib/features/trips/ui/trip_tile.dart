import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/list_card.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/trip_status_ui.dart';

/// A trip in a list: number and status, route, departure, car and drivers, how much is loaded, the moves it carries.
class TripTile extends StatelessWidget {
  const TripTile({required this.trip, required this.onTap, super.key});

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = trip;
    final crew = [
      ?t.carPlateNumber,
      ?t.driverName,
      ?t.coDriverName,
    ].join(' · ');
    // planned includes what is already loaded by the plan; loaded counts what was handed out on the way as well,
    // and may go over the plan (taken on the spot)
    final hasCargo = t.plannedCount + t.loadedCount > 0;
    final loadText = t.plannedCount == 0
        ? l.trip_loadProgressNoPlan(t.loadedCount)
        : t.loadedCount > t.plannedCount
        ? l.trip_loadProgressOverPlan(t.loadedCount, t.plannedCount)
        : l.trip_loadProgress(t.loadedCount, t.plannedCount);
    final small = theme.textTheme.bodySmall;
    return ListCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l.trip_one(t.shownNumber),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TripStatusChip(t.status),
            ],
          ),
          if (t.route.isNotEmpty)
            CardLine(
              Icons.place_outlined,
              t.route,
              maxLines: 2,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              color: theme.colorScheme.onSurface,
            ),
          CardLine(Icons.schedule, formatDateTime(t.plannedDepartureAt)),
          if (crew.isNotEmpty) CardLine(Icons.local_shipping_outlined, crew),
          if (hasCargo)
            CardLine(
              Icons.inventory_2_outlined,
              [
                loadText,
                if (t.deliveredCount > 0)
                  l.trip_deliveredShort(t.deliveredCount),
              ].join(' · '),
            ),
          // a trip of moves says what it carries (two at most, then «ще N»)
          if (t.moves.isNotEmpty) ...[
            const SizedBox(height: 6),
            const Divider(height: 1),
            const SizedBox(height: 2),
            for (final m in t.moves.take(2))
              CardLine(
                Icons.chair_outlined,
                [
                  ?m.barcode,
                  ?m.clientName,
                  ?m.description,
                  l.trip_moveSeats(m.seats),
                ].join(' · '),
                style: small,
              ),
            if (t.moves.length > 2)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 22),
                child: Text(l.trip_moreMoves(t.moves.length - 2), style: small),
              ),
          ],
        ],
      ),
    );
  }
}
