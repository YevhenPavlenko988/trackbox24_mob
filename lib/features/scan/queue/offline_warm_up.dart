import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/features/auth/state/auth_notifier.dart';
import 'package:trackbox24_mob/features/company/data/company_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_api.dart';
import 'package:trackbox24_mob/features/trips/data/trip_model.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_api.dart';

/// Fills the offline cache while there is a connection, so a dead zone finds everything a scan needs even if the
/// driver opened nothing: the open trips with their parcels and moves (each card kept from the trip's list), the
/// trips a scan can load into, the warehouses and the company. Runs after login, when the connection returns, when
/// the app comes back to the foreground and every [period]; at most once per [minGap]. Failures are ignored.
class OfflineWarmUp {
  OfflineWarmUp(
    this._ref, {
    this.period = const Duration(minutes: 15),
    this.minGap = const Duration(minutes: 2),
  });

  final Ref _ref;
  final Duration period;
  final Duration minGap;

  /// Trips worth having offline; more would only slow the phone down.
  static const maxTrips = 20;

  Timer? _timer;
  StreamSubscription<List<ConnectivityResult>>? _connectivity;
  DateTime? _lastRun;
  bool _running = false;

  void start() {
    _connectivity ??= Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) unawaited(run());
    });
    _timer ??= Timer.periodic(period, (_) => unawaited(run()));
    unawaited(run());
  }

  void dispose() {
    _timer?.cancel();
    unawaited(_connectivity?.cancel());
  }

  Future<void> run({bool force = false}) async {
    if (_running || _ref.read(authProvider) is! Authenticated) return;
    final last = _lastRun;
    if (!force && last != null && DateTime.now().difference(last) < minGap) {
      return;
    }
    _running = true;
    try {
      final trips = _ref.read(tripApiProvider);
      final open = (await trips.list(
        statuses: const [...loadableTripStatuses, TripStatus.IN_PROGRESS],
      )).content;
      // the exact list the pickers ask for, under its own key
      await trips.list(statuses: loadableTripStatuses);
      final routes = <int>{};
      for (final trip in open.take(maxTrips)) {
        await trips.get(trip.id);
        await trips.parcels(trip.id);
        if (trip.routeId != null) routes.add(trip.routeId!);
      }
      // the whole way of each route, for the transfer hint and the legs on the card
      for (final routeId in routes) {
        await trips.routeLegs(routeId);
      }
      await _ref.read(warehouseApiProvider).listActive();
      await _ref.read(companyApiProvider).current();
      _lastRun = DateTime.now();
    } on Object {
      // no connection after all, or the server said no: the next trigger tries again
    } finally {
      _running = false;
    }
  }
}

final offlineWarmUpProvider = Provider<OfflineWarmUp>((ref) {
  final warmUp = OfflineWarmUp(ref);
  ref.onDispose(warmUp.dispose);
  return warmUp;
});
