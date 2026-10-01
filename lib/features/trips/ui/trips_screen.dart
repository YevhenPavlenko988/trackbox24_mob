import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/ui/async_view.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
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
        floatingActionButton: isDriver
            ? FloatingActionButton(
                onPressed: () => context.push('/trips/new'),
                child: const Icon(Icons.add),
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
                separatorBuilder: (_, _) => const Divider(height: 1),
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

/// Picks a trip that still accepts loading; pops with the chosen [Trip].
class TripPickScreen extends StatelessWidget {
  const TripPickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l.trips_pickTitle)),
      body: TripList(
        statuses: const [TripStatus.PREPARING, TripStatus.PLANNED],
        onTap: (t) => context.pop(t),
      ),
    );
  }
}
