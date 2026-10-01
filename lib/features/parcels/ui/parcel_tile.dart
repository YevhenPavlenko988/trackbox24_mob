import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';

/// One parcel in a list: code, status, sender/client, seats, paid-storage warning.
class ParcelTile extends StatelessWidget {
  const ParcelTile({required this.parcel, required this.onTap, super.key});

  final Parcel parcel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final p = parcel;
    final storageDue =
        p.status == ParcelStatus.IN_NOVA_POSHTA && p.paidStorageDue;
    final subtitle = [
      if (p.senderName != null) '${l.parcel_sender}: ${p.senderName}',
      if (p.clientName != null) '${l.parcel_client}: ${p.clientName}',
      if (p.description != null && p.description!.isNotEmpty) p.description!,
    ].join('\n');

    return ListTile(
      onTap: onTap,
      tileColor: storageDue
          ? theme.colorScheme.errorContainer.withValues(alpha: 0.35)
          : null,
      title: Row(
        children: [
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
          if (p.needsEnrichment)
            Text(
              l.parcel_needsEnrichment,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.orange.shade800,
              ),
            ),
          if (p.npPaidStorageFrom != null &&
              p.status == ParcelStatus.IN_NOVA_POSHTA)
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
