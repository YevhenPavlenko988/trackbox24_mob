import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Where the items of a move were scanned when «Закінчили сканування» is pressed.
enum SeatCheckStage { LOAD, WAREHOUSE, DELIVER }

/// How many items are where they should be after the stage, and which are missing.
class SeatCheck {
  const SeatCheck({
    required this.stage,
    required this.total,
    required this.done,
    required this.missing,
  });

  factory SeatCheck.fromJson(Map<String, dynamic> json) => SeatCheck(
    stage: SeatCheckStage.values.byName(json['stage'] as String),
    total: (json['total'] as num?)?.toInt() ?? 0,
    done: (json['done'] as num?)?.toInt() ?? 0,
    missing: [
      for (final s in (json['missing'] as List? ?? const []))
        Seat.fromJson((s as Map).cast<String, dynamic>()),
    ],
  );

  final SeatCheckStage stage;
  final int total;
  final int done;
  final List<Seat> missing;

  bool get complete => missing.isEmpty;
}
