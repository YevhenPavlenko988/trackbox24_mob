import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/trip_status_ui.dart';

class TripTile extends StatelessWidget {
  const TripTile({required this.trip, required this.onTap, super.key});

  final Trip trip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final t = trip;
    final line2 = [
      if (t.carPlateNumber != null) t.carPlateNumber!,
      if (t.driverName != null) t.driverName!,
    ].join(' · ');
    return ListTile(
      onTap: onTap,
      title: Row(
        children: [
          Expanded(
            child: Text(
              l.trip_one(t.id),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TripStatusChip(t.status),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l.trip_plannedDepartureAt}: ${formatDateTime(t.plannedDepartureAt)}',
          ),
          if (t.route.isNotEmpty) Text(t.route),
          if (line2.isNotEmpty)
            Text(line2, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
      isThreeLine: true,
    );
  }
}
