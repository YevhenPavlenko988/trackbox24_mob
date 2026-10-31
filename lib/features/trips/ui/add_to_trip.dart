import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_api.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/queue/scan_queue_worker.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_tile.dart';

/// A driver puts a parcel they hold (e.g. one just accepted in person) into a trip: one of their trips that
/// still loads, or a trip created on the spot. Every seat is loaded the way a scan would, so the offline queue
/// and the backend rules (own trip, car and driver assigned, not departed) apply as usual.
Future<void> addParcelToTrip(
  BuildContext context,
  WidgetRef ref,
  Parcel parcel,
) async {
  final l = AppLocalizations.of(context);
  final messenger = ScaffoldMessenger.of(context);
  final trip = await showModalBottomSheet<Trip>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _TripSheet(),
  );
  if (trip == null || !context.mounted) return;

  final codes = parcel.seats.length > 1
      ? [
          for (final s in parcel.seats)
            if (s.barcode != null) s.barcode!,
        ]
      : [if (parcel.barcode != null) parcel.barcode!];
  final service = ref.read(scanServiceProvider);
  var queued = false;
  var loaded = false;
  String? problem;
  for (final code in codes) {
    final outcome = await service.perform(
      ScanMode.load,
      code,
      params: ScanParams(tripId: trip.id),
    );
    switch (outcome) {
      case ScanSuccess():
        loaded = true;
      case ScanQueued():
        queued = true;
      case ScanFailure(:final error):
        problem = context.mounted ? describeError(context, error) : null;
      case ScanRejected():
        problem = l.scanAction_badCode;
    }
    if (problem != null) break;
  }
  ref
    ..invalidate(parcelProvider(parcel.id))
    ..invalidate(parcelHistoryProvider(parcel.id));
  invalidateTrip(ref, trip.id);
  if (loaded) unawaited(ref.read(scanQueueWorkerProvider).run());
  messenger.showSnackBar(
    SnackBar(
      content: Text(
        problem ??
            (queued ? l.scan_queued : l.trip_parcelAdded(trip.shownNumber)),
      ),
    ),
  );
}

/// The driver's trips that still load, newest first, and a way to start a new one.
class _TripSheet extends ConsumerWidget {
  const _TripSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    const statuses = loadableTripStatuses;
    final trips = ref.watch(tripsByStatusProvider(statuses));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.trip_addParcel, style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(l.trip_addParcelHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Flexible(
              child: switch (trips) {
                AsyncData(:final value) =>
                  value.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            l.trip_addParcelNoTrips,
                            style: theme.textTheme.bodyMedium,
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          itemCount: value.length,
                          separatorBuilder: (_, _) => const Divider(height: 1),
                          itemBuilder: (context, i) => TripTile(
                            trip: value[i],
                            onTap: () => Navigator.of(context).pop(value[i]),
                          ),
                        ),
                AsyncError(:final error) => ErrorView(
                  error: error,
                  onRetry: () =>
                      ref.invalidate(tripsByStatusProvider(statuses)),
                ),
                _ => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
              },
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final created = await context.push<Trip>('/trips/new?pick=1');
                if (created != null) navigator.pop(created);
              },
              icon: const Icon(Icons.add),
              label: Text(l.trip_addParcelNew),
            ),
          ],
        ),
      ),
    );
  }
}
