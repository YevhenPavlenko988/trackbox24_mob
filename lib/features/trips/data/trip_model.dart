import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

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

    /// What people see: 1, 2, 3 … within the company; the id stays for requests.
    int? number,
    @JsonKey(unknownEnumValue: TripStatus.unknown) TripStatus? status,
    int? carId,
    String? carPlateNumber,
    int? driverId,
    String? driverName,
    int? coDriverId,
    String? coDriverName,
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
    TripPayments? payments,
  }) = _Trip;

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  const Trip._();

  /// The number to show; an older backend without it — the id.
  int get shownNumber => number ?? id;

  bool get isOpen =>
      status == TripStatus.PLANNED ||
      status == TripStatus.PREPARING ||
      status == TripStatus.IN_PROGRESS;

  /// Scans with this trip are accepted (loading phase).
  bool get acceptsLoading =>
      status == TripStatus.PLANNED || status == TripStatus.PREPARING;

  bool get canDepart => acceptsLoading && carId != null && driverId != null;

  /// The user drives this trip, as the main or the second driver; both have the same rights on it.
  bool isDrivenBy(int userId) => driverId == userId || coDriverId == userId;

  String get route => [
    origin,
    destination,
  ].whereType<String>().where((s) => s.isNotEmpty).join(' → ');
}

/// Our delivery money of the trip, grouped by currency and payment method; a representative gets none of it.
@freezed
abstract class TripPayments with _$TripPayments {
  const factory TripPayments({
    @Default([]) List<TripPaymentLine> received,
    @Default([]) List<TripPaymentLine> notReceived,
  }) = _TripPayments;
  const TripPayments._();

  factory TripPayments.fromJson(Map<String, dynamic> json) =>
      _$TripPaymentsFromJson(json);

  bool get isEmpty => received.isEmpty && notReceived.isEmpty;
}

@freezed
abstract class TripPaymentLine with _$TripPaymentLine {
  const factory TripPaymentLine({
    String? currency,
    @JsonKey(unknownEnumValue: PaymentMethod.unknown) PaymentMethod? method,
    @Default(0) double amount,
    @Default(0) int parcels,
  }) = _TripPaymentLine;

  factory TripPaymentLine.fromJson(Map<String, dynamic> json) =>
      _$TripPaymentLineFromJson(json);
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
