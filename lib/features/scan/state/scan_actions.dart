import 'package:flutter/material.dart';
import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';
import 'package:trackbox24_mob/features/auth/data/user_model.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/scan/state/scan_service.dart';

/// One thing the user can do with the parcel just scanned.
class ScanAction {
  const ScanAction(
    this.mode,
    this.icon, {
    this.needsTrip = false,
    this.needsWarehouse = false,
    this.labelOverride,
  });

  final ScanMode mode;
  final IconData icon;

  /// Set where the wording depends on the status, e.g. collecting at the branch vs confirming what we already hold.
  final String Function(AppLocalizations l)? labelOverride;

  /// The trip to load into; asked for before the action runs.
  final bool needsTrip;

  /// The warehouse to move to; asked for before the action runs.
  final bool needsWarehouse;

  String label(AppLocalizations l) =>
      labelOverride?.call(l) ?? _defaultLabel(l);

  String _defaultLabel(AppLocalizations l) => switch (mode) {
    ScanMode.receive => l.scanAction_receive,
    ScanMode.load => l.scanAction_load,
    ScanMode.deliver => l.scanAction_deliver,
    ScanMode.toWarehouse => l.scanAction_toWarehouse,
    ScanMode.lookup => l.scan_mode_lookup,
  };
}

const _receive = ScanAction(ScanMode.receive, Icons.inventory_2_outlined);

/// Nova Poshta already handed it over, so there is nothing to collect: the representative confirms it is with us.
final _confirmReceipt = ScanAction(
  ScanMode.receive,
  Icons.check_circle_outline,
  labelOverride: (l) => l.scanAction_confirmReceipt,
);
const _load = ScanAction(
  ScanMode.load,
  Icons.local_shipping_outlined,
  needsTrip: true,
);
const _deliver = ScanAction(ScanMode.deliver, Icons.how_to_reg_outlined);
const _toWarehouse = ScanAction(
  ScanMode.toWarehouse,
  Icons.warehouse_outlined,
  needsWarehouse: true,
);

/// Roles the backend lets perform each action.
bool _allowed(ScanMode mode, User user) => switch (mode) {
  ScanMode.receive => user.isRepresentative || user.isManager,
  ScanMode.toWarehouse =>
    user.isRepresentative || user.isDriver || user.isManager,
  ScanMode.load => user.isRepresentative || user.isDriver || user.isManager,
  ScanMode.deliver => user.isDriver || user.isManager,
  ScanMode.lookup => true,
};

/// What this parcel can move to next, in the order the flow usually goes. Empty for a finished parcel.
List<ScanAction> actionsFor(Parcel parcel, User? user) {
  if (user == null) return const [];
  final byStatus = switch (parcel.status) {
    ParcelStatus.IN_NOVA_POSHTA => [_receive],
    ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA => [_confirmReceipt],
    ParcelStatus.RECEIVED_BY_REPRESENTATIVE => [_load, _toWarehouse],
    ParcelStatus.AT_WAREHOUSE => [_load, _deliver, _toWarehouse],
    ParcelStatus.IN_CAR => [_deliver, _toWarehouse],
    _ => const <ScanAction>[],
  };
  return [
    for (final a in byStatus)
      if (_allowed(a.mode, user)) a,
  ];
}

/// Offline the status is unknown, so the code itself decides: a waybill can only be collected.
List<ScanAction> actionsForCode(String code, User? user) {
  if (user == null) return const [];
  final candidates = ttnOf(code) != null
      ? [_receive]
      : [_load, _deliver, _toWarehouse];
  return [
    for (final a in candidates)
      if (_allowed(a.mode, user)) a,
  ];
}
