import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/core/ui/error_text.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/ui/parcel_tile.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/trip_logic.dart';
import 'package:trackbox24_mob/features/trips/trip_status_ui.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_dialogs.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_payments_view.dart';

class TripDetailScreen extends ConsumerWidget {
  const TripDetailScreen({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final trip = ref.watch(tripProvider(id));
    return Scaffold(
      // the number arrives with the trip; until then just «Рейс»
      appBar: AppBar(
        title: Text(
          trip.value == null
              ? l.trip_untitled
              : l.trip_one(trip.value!.shownNumber),
        ),
      ),
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
    final isMyTrip = user != null && user.isDriver && t.isDrivenBy(user.id);
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
          if (t.isLeg && t.number != null && t.legNumber != null)
            KvRow(l.trip_routeLabel, l.trip_routeLeg(t.number!, t.legNumber!)),
          KvRow(l.trip_car, t.carPlateNumber),
          KvRow(l.trip_driver, t.driverName),
          if (t.coDriverName != null) KvRow(l.trip_coDriver, t.coDriverName),
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

          // The whole way of the route: every leg with its car and driver, the driver's own ones stand out
          if (t.isLeg && t.routeId != null)
            RouteLegsSection(
              routeId: t.routeId!,
              current: t.id,
              userId: user?.id,
            ),

          // Money of the trip; a representative gets no payments from the backend at all.
          if (t.payments != null && !t.payments!.isEmpty) ...[
            const SizedBox(height: 16),
            Text(l.trip_payments, style: theme.textTheme.titleSmall),
            const SizedBox(height: 4),
            TripPaymentsView(payments: t.payments!),
          ],

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
                // The route goes on with another car or after a warehouse: the driver adds the next leg on the way.
                if (t.isLeg && isMyTrip && t.status != TripStatus.CANCELLED)
                  OutlinedButton.icon(
                    onPressed: () => context.push(
                      Uri(
                        path: '/trips/new',
                        queryParameters: {
                          'routeId': '${t.routeId}',
                          'leg': legNo(
                            t.number ?? t.id,
                            (t.legNumber ?? 0) + 1,
                          ),
                          if ((t.destination ?? '').isNotEmpty)
                            'from': t.destination,
                        },
                      ).toString(),
                    ),
                    icon: const Icon(Icons.alt_route),
                    label: Text(l.trip_nextLeg),
                  ),
                // A move made on the spot goes straight into this trip: its labels, then the scan.
                if ((t.status == TripStatus.PLANNED || t.acceptsLoading) &&
                    isMyTrip &&
                    ref.watch(movesEnabledProvider))
                  FilledButton.tonalIcon(
                    onPressed: () => context.push('/moves/new?tripId=${t.id}'),
                    icon: const Icon(Icons.chair_outlined),
                    label: Text(l.move_new),
                  ),
                // Loading normally starts with the first scan; this is for a car packed away from the scanner.
                if (t.status == TripStatus.PLANNED && isMyTrip)
                  FilledButton.tonalIcon(
                    onPressed: t.canDepart
                        ? () => startLoadingTrip(context, ref, t)
                        : null,
                    icon: const Icon(Icons.inbox_outlined),
                    label: Text(l.trip_startLoading),
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

/// The legs of the route in order. The driver's own legs are coloured and open; the others show who takes over;
/// the leg loading or on the road is framed, whoever's it is.
class RouteLegsSection extends ConsumerWidget {
  const RouteLegsSection({
    required this.routeId,
    required this.current,
    this.userId,
    super.key,
  });

  final int routeId;
  final int current;
  final int? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final legs = ref.watch(routeLegsProvider(routeId)).value;
    if (legs == null || legs.length < 2) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        Text(l.trip_routeLegs, style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        for (final leg in legs)
          _LegTile(
            leg: leg,
            mine: userId != null && leg.isDrivenBy(userId!),
            here: leg.id == current,
          ),
      ],
    );
  }
}

class _LegTile extends StatelessWidget {
  const _LegTile({required this.leg, required this.mine, required this.here});

  final Trip leg;
  final bool mine;
  final bool here;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final who = [?leg.carPlateNumber, ?leg.driverName].join(' · ');
    final active =
        leg.status == TripStatus.PREPARING ||
        leg.status == TripStatus.IN_PROGRESS;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 3),
      elevation: 0,
      color: mine
          ? scheme.primaryContainer
          : scheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // where the cargo is now: the leg loading or on the road, whoever's it is
        side: active
            ? BorderSide(color: scheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: ListTile(
        dense: true,
        // another driver's leg is shown, not opened: its card is theirs
        onTap: mine && !here ? () => context.push('/trips/${leg.id}') : null,
        leading: CircleAvatar(
          radius: 16,
          backgroundColor: mine ? scheme.primary : scheme.outlineVariant,
          foregroundColor: mine ? scheme.onPrimary : scheme.onSurfaceVariant,
          child: Text(
            '${leg.legNumber ?? ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          [leg.shownNumber, if (leg.route.isNotEmpty) leg.route].join('  '),
          style: TextStyle(
            fontWeight: mine ? FontWeight.w700 : FontWeight.w500,
            color: mine ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Wrap(
            spacing: 6,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                [
                  if (who.isNotEmpty) who,
                  formatDateTime(leg.plannedDepartureAt),
                ].join(' · '),
                style: TextStyle(
                  color: mine
                      ? scheme.onPrimaryContainer
                      : scheme.onSurfaceVariant,
                ),
              ),
              TripStatusChip(leg.status),
            ],
          ),
        ),
      ),
    );
  }
}
