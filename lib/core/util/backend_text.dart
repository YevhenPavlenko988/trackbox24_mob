import 'package:trackbox24_mob/core/l10n/generated/app_localizations.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';
import 'package:trackbox24_mob/features/parcels/parcel_status_ui.dart';

/// The backend writes history comments in English ("Loading started", "To warehouse X").
/// Known phrases are translated here; anything else (user-typed comments) passes through.
String? translateComment(AppLocalizations l, String? comment) {
  if (comment == null || comment.isEmpty) return comment;
  for (final rule in _rules) {
    final m = rule.re.firstMatch(comment);
    if (m != null) return rule.text(l, m);
  }
  return comment;
}

class _Rule {
  const _Rule(this.re, this.text);

  final RegExp re;
  final String Function(AppLocalizations l, RegExpMatch m) text;
}

String _status(AppLocalizations l, String raw) {
  final s = ParcelStatus.values.where((v) => v.name == raw).firstOrNull;
  return s == null ? raw : parcelStatusLabel(l, s);
}

final _rules = <_Rule>[
  _Rule(RegExp(r'^Loading started$'), (l, _) => l.comment_loadingStarted),
  _Rule(RegExp(r'^Departed$'), (l, _) => l.comment_departed),
  _Rule(
    RegExp(r'^Departed, odometer (\d+) km$'),
    (l, m) => l.comment_departedOdometer(int.parse(m[1]!)),
  ),
  _Rule(RegExp(r'^Completed$'), (l, _) => l.comment_completed),
  _Rule(
    RegExp(r'^Completed, odometer (\d+) km$'),
    (l, m) => l.comment_completedOdometer(int.parse(m[1]!)),
  ),
  _Rule(RegExp(r'^Outside the plan$'), (l, _) => l.comment_outsidePlan),
  _Rule(
    RegExp(r'^Loaded outside the plan$'),
    (l, _) => l.comment_loadedOutsidePlan,
  ),
  _Rule(
    RegExp(r'^Loaded outside the plan\. (.+)$', dotAll: true),
    (l, m) => l.comment_loadedOutsidePlanComment(m[1]!),
  ),
  _Rule(
    RegExp(r'^Not loaded before departure$'),
    (l, _) => l.comment_notLoadedBeforeDeparture,
  ),
  _Rule(
    RegExp(r'^Re-planned to trip (\d+)$'),
    (l, m) => l.comment_replanned(int.parse(m[1]!)),
  ),
  _Rule(
    RegExp(r'^To warehouse (.+)$', dotAll: true),
    (l, m) => l.comment_toWarehouse(m[1]!),
  ),
  _Rule(RegExp(r'^Trip cancelled$'), (l, _) => l.comment_tripCancelled),
  _Rule(
    RegExp(r'^Trip cancelled, to warehouse (.+)$', dotAll: true),
    (l, m) => l.comment_tripCancelledToWarehouse(m[1]!),
  ),
  _Rule(
    RegExp(r'^All (\d+) seats$'),
    (l, m) => l.comment_allSeats(int.parse(m[1]!)),
  ),
  _Rule(RegExp(r'^Created manually$'), (l, _) => l.comment_createdManually),
  _Rule(
    RegExp(r'^Created manually as already received$'),
    (l, _) => l.comment_createdManuallyReceived,
  ),
  _Rule(
    RegExp(
      r'^Redirected by Nova Poshta: waybill (\d+) -> (\d+), parcel #(\d+) merged$',
    ),
    (l, m) => l.comment_npRedirected(m[1]!, m[2]!, int.parse(m[3]!)),
  ),
  _Rule(
    RegExp(r'^Manual status change to ([A-Z_]+)$'),
    (l, m) => l.comment_manualStatusChange(_status(l, m[1]!)),
  ),
];
