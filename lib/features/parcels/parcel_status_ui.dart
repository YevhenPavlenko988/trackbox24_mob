import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

String parcelStatusLabel(AppLocalizations l, ParcelStatus? s) => switch (s) {
  ParcelStatus.IN_NOVA_POSHTA => l.parcelStatus_IN_NOVA_POSHTA,
  ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA =>
    l.parcelStatus_PICKED_UP_FROM_NOVA_POSHTA,
  ParcelStatus.RECEIVED_BY_REPRESENTATIVE =>
    l.parcelStatus_RECEIVED_BY_REPRESENTATIVE,
  ParcelStatus.AT_WAREHOUSE => l.parcelStatus_AT_WAREHOUSE,
  ParcelStatus.IN_CAR => l.parcelStatus_IN_CAR,
  ParcelStatus.DELIVERED_TO_CLIENT => l.parcelStatus_DELIVERED_TO_CLIENT,
  ParcelStatus.CANCELLED => l.parcelStatus_CANCELLED,
  _ => '—',
};

Color parcelStatusColor(ParcelStatus? s) => switch (s) {
  ParcelStatus.IN_NOVA_POSHTA => Colors.amber.shade700,
  ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA => Colors.orange.shade800,
  ParcelStatus.RECEIVED_BY_REPRESENTATIVE => Colors.blue.shade700,
  ParcelStatus.AT_WAREHOUSE => Colors.teal.shade700,
  ParcelStatus.IN_CAR => Colors.deepPurple.shade600,
  ParcelStatus.DELIVERED_TO_CLIENT => Colors.green.shade700,
  ParcelStatus.CANCELLED => Colors.grey.shade600,
  _ => Colors.grey,
};

class ParcelStatusChip extends StatelessWidget {
  const ParcelStatusChip(this.status, {super.key});

  final ParcelStatus? status;

  @override
  Widget build(BuildContext context) {
    final color = parcelStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        parcelStatusLabel(AppLocalizations.of(context), status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
