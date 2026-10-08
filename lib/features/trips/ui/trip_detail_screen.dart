import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_tile.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/trip_logic.dart';
import 'package:trackbox24_mob/features/trips/trip_status_ui.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_dialogs.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final trip = ref.watch(tripProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(l.trip_one(id))),
      body: switch (trip) {
        AsyncData(:final value) => _Body(trip: value),
        AsyncError(:final error) => ErrorView(
          error: error,
          onRetry: () => invalidateTrip(ref, id),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.trip});

  final Trip trip;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final t = trip;
    final user = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user,
      _ => null,
    };
    final isMyTrip = user != null && user.isDriver && t.driverId == user.id;
    final parcelsAsync = ref.watch(tripParcelsProvider(t.id));
    final parcels = parcelsAsync.value ?? const <Parcel>[];
    final split = splitTripParcels(t.id, parcels);
    final progress = seatProgress(split.loaded);

    Future<void> openScan(String path) async {
      await context.push(path);
      invalidateTrip(ref, t.id);
    }

    return RefreshIndicator(
      onRefresh: () async => invalidateTrip(ref, t.id),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          Row(
            children: [
              TripStatusChip(t.status),
              const SizedBox(width: 8),
              if (t.route.isNotEmpty)
                Expanded(
                  child: Text(t.route, style: theme.textTheme.titleMedium),
                ),
            ],
          ),
          const SizedBox(height: 8),
          KvRow(l.trip_car, t.carPlateNumber),
          KvRow(l.trip_driver, t.driverName),
          KvRow(
            l.trip_plannedDepartureAt,
            formatDateTime(t.plannedDepartureAt),
          ),
          if (t.plannedArrivalAt != null)
            KvRow(l.trip_plannedArrivalAt, formatDateTime(t.plannedArrivalAt)),
          if (t.departedAt != null)
            KvRow(l.trip_departedAt, formatDateTime(t.departedAt)),
          if (t.arrivedAt != null)
            KvRow(l.trip_arrivedAt, formatDateTime(t.arrivedAt)),
          if (t.startOdometerKm != null)
            KvRow(l.trip_startOdometerKm, '${t.startOdometerKm}'),
          if (t.endOdometerKm != null)
            KvRow(l.trip_endOdometerKm, '${t.endOdometerKm}'),
          KvRow(l.trip_notes, t.notes),

          // ----- actions -----
          if (t.isOpen) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (t.acceptsLoading &&
                    (isMyTrip || (user?.isRepresentative ?? false)))
                  FilledButton.tonalIcon(
                    onPressed: () => openScan('/scan/load/${t.id}'),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(l.scan_mode_load),
                  ),
                if (t.acceptsLoading && isMyTrip)
                  FilledButton.icon(
                    onPressed: t.canDepart
                        ? () => showDepartDialog(context, ref, t)
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l.trip_depart),
                  ),
                if (t.status == TripStatus.IN_PROGRESS && isMyTrip) ...[
                  FilledButton.tonalIcon(
                    onPressed: () => openScan('/scan/deliver'),
                    icon: const Icon(Icons.handshake_outlined),
                    label: Text(l.scan_mode_deliver),
                  ),
                  FilledButton.icon(
                    onPressed: () => showCompleteDialog(context, ref, t),
                    icon: const Icon(Icons.flag),
                    label: Text(l.trip_complete),
                  ),
                ],
              ],
            ),
            if (t.acceptsLoading && isMyTrip && !t.canDepart)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l.trip_departHint,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
          ],

          // ----- plan -----
          if (t.acceptsLoading) ...[
            SectionTitle('${l.trip_plan} (${split.planned.length})'),
            Text(l.trip_planHint, style: theme.textTheme.bodySmall),
            if (parcelsAsync.isLoading) const LinearProgressIndicator(),
            if (parcelsAsync.hasValue && split.planned.isEmpty)
              _muted(context, l.trip_noPlan),
            for (final p in split.planned)
              ParcelTile(
                parcel: p,
                onTap: () => context.push('/parcels/${p.id}'),
              ),
          ],

          // ----- loaded / delivered -----
          SectionTitle('${l.trip_loaded} (${split.loaded.length})'),
          Text(
            l.trip_loadedProgress(
              progress.loaded,
              progress.total,
              progress.delivered,
            ),
            style: theme.textTheme.bodySmall,
          ),
          if (parcelsAsync.isLoading) const LinearProgressIndicator(),
          if (parcelsAsync.hasError)
            Text(
              describeError(context, parcelsAsync.error!),
              style: TextStyle(color: theme.colorScheme.error),
            ),
          if (parcelsAsync.hasValue && split.loaded.isEmpty)
            _muted(
              context,
              t.acceptsLoading ? l.trip_noLoaded : l.trip_noLoadedClosed,
            ),
          for (final p in split.loaded)
            Stack(
              children: [
                ParcelTile(
                  parcel: p,
                  onTap: () => context.push('/parcels/${p.id}'),
                ),
                if (isOutsidePlan(t.id, p))
                  Positioned(
                    right: 16,
                    bottom: 6,
                    child: Text(
                      l.trip_outsidePlan,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ),
              ],
            ),

          SectionTitle(l.trip_history),
          _History(id: t.id),
        ],
      ),
    );
  }

  Widget _muted(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
  );
}

class _History extends ConsumerWidget {
  const _History({required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return switch (ref.watch(tripHistoryProvider(id))) {
      AsyncData(:final value) when value.isEmpty => Text(
        l.trip_historyEmpty,
        style: theme.textTheme.bodySmall,
      ),
      AsyncData(:final value) => Column(
        children: [
          for (final e in value.reversed)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Row(
                children: [
                  Text(
                    formatDateTime(e.changedAt),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tripEventLabel(l, e.event),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (e.parcelBarcode != null)
                    InkWell(
                      onTap: e.parcelId == null
                          ? null
                          : () => context.push('/parcels/${e.parcelId}'),
                      child: Text(
                        e.parcelBarcode!,
                        style: TextStyle(
                          fontFamily: 'monospace',
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  if (e.event == TripEvent.STATUS_CHANGED)
                    Wrap(
                      spacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (e.previousStatus != null) ...[
                          TripStatusChip(e.previousStatus),
                          const Icon(Icons.arrow_forward, size: 14),
                        ],
                        TripStatusChip(e.status),
                      ],
                    ),
                  if (e.changedByName != null || e.comment != null)
                    Text(
                      [
                        e.changedByName,
                        e.comment,
                      ].whereType<String>().join(' — '),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
        ],
      ),
      AsyncError(:final error) => Text(
        describeError(context, error),
        style: TextStyle(color: theme.colorScheme.error),
      ),
      _ => const Padding(
        padding: EdgeInsets.all(8),
        child: LinearProgressIndicator(),
      ),
    };
  }
}
