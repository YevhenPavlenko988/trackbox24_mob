import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';

String tripStatusLabel(AppLocalizations l, TripStatus? s) => switch (s) {
  TripStatus.PLANNED => l.tripStatus_PLANNED,
  TripStatus.PREPARING => l.tripStatus_PREPARING,
  TripStatus.IN_PROGRESS => l.tripStatus_IN_PROGRESS,
  TripStatus.COMPLETED => l.tripStatus_COMPLETED,
  TripStatus.CANCELLED => l.tripStatus_CANCELLED,
  _ => '—',
};

Color tripStatusColor(TripStatus? s) => switch (s) {
  TripStatus.PLANNED => Colors.blueGrey.shade600,
  TripStatus.PREPARING => Colors.blue.shade700,
  TripStatus.IN_PROGRESS => Colors.deepPurple.shade600,
  TripStatus.COMPLETED => Colors.green.shade700,
  TripStatus.CANCELLED => Colors.grey.shade600,
  _ => Colors.grey,
};

class TripStatusChip extends StatelessWidget {
  const TripStatusChip(this.status, {super.key});

  final TripStatus? status;

  @override
  Widget build(BuildContext context) {
    final color = tripStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        tripStatusLabel(AppLocalizations.of(context), status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

String tripEventLabel(AppLocalizations l, TripEvent? e) => switch (e) {
  TripEvent.CREATED => l.tripEvent_CREATED,
  TripEvent.UPDATED => l.tripEvent_UPDATED,
  TripEvent.STATUS_CHANGED => l.tripEvent_STATUS_CHANGED,
  TripEvent.PARCEL_PLANNED => l.tripEvent_PARCEL_PLANNED,
  TripEvent.PARCEL_UNPLANNED => l.tripEvent_PARCEL_UNPLANNED,
  TripEvent.PARCEL_LOADED => l.tripEvent_PARCEL_LOADED,
  TripEvent.PARCEL_DELIVERED => l.tripEvent_PARCEL_DELIVERED,
  TripEvent.PARCEL_UNLOADED => l.tripEvent_PARCEL_UNLOADED,
  _ => '—',
};
