import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

part 'parcel_history_model.freezed.dart';
part 'parcel_history_model.g.dart';

enum HistorySource { SCAN, MANUAL, NOVA_POSHTA, SYSTEM, unknown }

@freezed
abstract class ParcelHistoryEntry with _$ParcelHistoryEntry {
  const factory ParcelHistoryEntry({
    required int id,
    int? seatNumber,
    @JsonKey(unknownEnumValue: ParcelStatus.unknown)
    ParcelStatus? previousStatus,
    @JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status,
    int? warehouseId,
    String? warehouseName,
    String? npStatusCode,
    String? npStatusText,
    @JsonKey(unknownEnumValue: HistorySource.unknown) HistorySource? source,
    int? changedById,
    String? changedByName,
    DateTime? changedAt,
    String? comment,
  }) = _ParcelHistoryEntry;

  factory ParcelHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$ParcelHistoryEntryFromJson(json);
}
