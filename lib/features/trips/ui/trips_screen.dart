import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/state/company.dart';
import 'package:trackbox24_mob/features/moves/move_form_screen.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/trips/ui/trip_tile.dart';

const _tabs = [
  [TripStatus.PREPARING, TripStatus.IN_PROGRESS],
  [TripStatus.PLANNED],
  [TripStatus.COMPLETED, TripStatus.CANCELLED],
];

/// Driver's trips: current (loading / on the road), planned, finished.
class TripsScreen extends ConsumerWidget {
  const TripsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final parcels = ref.watch(parcelsEnabledProvider);
    final moves = ref.watch(movesEnabledProvider);
    final isDriver = switch (ref.watch(authProvider)) {
      Authenticated(:final user) => user.isDriver,
      _ => false,
    };
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l.nav_trips),
          bottom: TabBar(
            tabs: [
              Tab(text: l.trips_current),
              Tab(text: l.trips_planned),
              Tab(text: l.trips_finished),
            ],
          ),
        ),
        // A driver both starts their own trips and accepts parcels handed over in person (e.g. for the way back).
        floatingActionButton: isDriver
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'trip-new',
                    onPressed: () => context.push('/trips/new'),
                    icon: const Icon(Icons.add),
                    label: Text(l.trip_createTitle),
                  ),
                  // a parcel, a move or the choice of the two, as the company's modules allow
                  if (parcels || moves) ...[
                    const SizedBox(height: 12),
                    FloatingActionButton.extended(
                      heroTag: 'parcel-accept',
                      onPressed: () => startNewShipment(context, ref),
                      icon: Icon(
                        parcels
                            ? Icons.inventory_2_outlined
                            : Icons.chair_outlined,
                      ),
                      label: Text(
                        parcels && moves
                            ? l.trips_acceptAny
                            : parcels
                            ? l.trips_acceptParcel
                            : l.trips_acceptMove,
                      ),
                    ),
                  ],
                ],
              )
            : null,
        body: TabBarView(
          children: [
            for (final statuses in _tabs) TripList(statuses: statuses),
          ],
        ),
      ),
    );
  }
}

class TripList extends ConsumerWidget {
  const TripList({required this.statuses, this.onTap, super.key});

  final List<TripStatus> statuses;

  /// Defaults to opening the trip card.
  final void Function(Trip trip)? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final trips = ref.watch(tripsByStatusProvider(statuses));
    return switch (trips) {
      AsyncData(:final value) => RefreshIndicator(
        onRefresh: () => ref.refresh(tripsByStatusProvider(statuses).future),
        child: value.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: EmptyView(
                      text: l.trips_empty,
                      icon: Icons.local_shipping_outlined,
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: value.length,
                separatorBuilder: (_, _) => const SizedBox.shrink(),
                itemBuilder: (context, i) => TripTile(
                  trip: value[i],
                  onTap: () => onTap != null
                      ? onTap!(value[i])
                      : context.push('/trips/${value[i].id}'),
                ),
              ),
      ),
      AsyncError(:final error) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(tripsByStatusProvider(statuses)),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}

/// Picks a trip that still accepts loading; pops with the chosen [Trip]. «Новий рейс» makes one right here (a driver's,
/// on their car) from [from] to [to] — a move made on the spot always ends up in a trip.
class TripPickScreen extends StatelessWidget {
  const TripPickScreen({this.from, this.to, super.key});

  final String? from;
  final String? to;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.trips_pickTitle)),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        onPressed: () async {
          final created = await context.push<Trip>(
            Uri(
              path: '/trips/new',
              queryParameters: {
                'pick': '1',
                if ((from ?? '').isNotEmpty) 'from': from,
                if ((to ?? '').isNotEmpty) 'to': to,
              },
            ).toString(),
          );
          if (created != null && context.mounted) context.pop(created);
        },
        icon: const Icon(Icons.add),
        label: Text(l.trip_createTitle),
      ),
      body: TripList(
        statuses: loadableTripStatuses,
        onTap: (t) => context.pop(t),
      ),
    );
  }
}
