import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_model.freezed.dart';
part 'trip_model.g.dart';

enum TripStatus {
  PLANNED,
  PREPARING,
  IN_PROGRESS,
  COMPLETED,
  CANCELLED,
  unknown,
}

enum TripEvent {
  CREATED,
  UPDATED,
  STATUS_CHANGED,
  PARCEL_PLANNED,
  PARCEL_UNPLANNED,
  PARCEL_LOADED,
  PARCEL_DELIVERED,
  PARCEL_UNLOADED,
  DELETED,
  RESTORED,
  unknown,
}

@freezed
abstract class Trip with _$Trip {
  const factory Trip({
    required int id,
    @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status,
    int? carId,
    String? carPlateNumber,
    int? driverId,
    String? driverName,
    DateTime? plannedDepartureAt,
    DateTime? plannedArrivalAt,
    String? origin,
    String? destination,
    String? notes,
    DateTime? departedAt,
    DateTime? arrivedAt,
    int? startOdometerKm,
    int? endOdometerKm,
    @Default(0) int plannedCount,
    @Default(0) int loadedCount,
    @Default(0) int deliveredCount,
  }) = _Trip;
  const Trip._();

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  bool get isOpen =>
      status == TripStatus.PLANNED ||
      status == TripStatus.PREPARING ||
      status == TripStatus.IN_PROGRESS;

  /// Scans with this trip are accepted (loading phase).
  bool get acceptsLoading =>
      status == TripStatus.PLANNED || status == TripStatus.PREPARING;

  bool get canDepart => acceptsLoading && carId != null && driverId != null;

  String get route => [
    origin,
    destination,
  ].whereType<String>().where((s) => s.isNotEmpty).join(' → ');
}

@freezed
abstract class TripHistoryEntry with _$TripHistoryEntry {
  const factory TripHistoryEntry({
    required int id,
    @JsonKey(unknownEnumValue: TripEvent.unknown) TripEvent? event,
    @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? previousStatus,
    @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status,
    int? parcelId,
    String? parcelBarcode,
    int? changedById,
    String? changedByName,
    DateTime? changedAt,
    String? comment,
  }) = _TripHistoryEntry;

  factory TripHistoryEntry.fromJson(Map<String, dynamic> json) =>
      _$TripHistoryEntryFromJson(json);
}
