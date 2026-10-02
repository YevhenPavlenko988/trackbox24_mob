import 'package:freezed_annotation/freezed_annotation.dart';

part 'parcel_model.freezed.dart';
part 'parcel_model.g.dart';

enum ParcelStatus {
  IN_NOVA_POSHTA,
  RECEIVED_BY_REPRESENTATIVE,
  AT_WAREHOUSE,
  IN_CAR,
  DELIVERED_TO_CLIENT,
  CANCELLED,
  unknown,
}

enum PaymentStatus { UNPAID, PAID, unknown }

enum ParcelSource { NOVA_POSHTA, MANUAL, unknown }

/// Nova Poshta's own status, grouped by the backend. Independent of our [ParcelStatus].
enum NpState {
  CREATED,
  IN_TRANSIT,
  ARRIVED,
  RECEIVED,
  REDIRECTED,
  RETURNING,
  DELIVERY_FAILED,
  NOT_FOUND,
  OTHER,
  unknown,
}

@freezed
abstract class Seat with _$Seat {
  const factory Seat({
    required int seatNumber,
    String? barcode,
    @JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status,
    DateTime? statusChangedAt,
    String? statusChangedBy,
    int? warehouseId,
    String? warehouseName,
  }) = _Seat;

  factory Seat.fromJson(Map<String, dynamic> json) => _$SeatFromJson(json);
}

/// `ParcelResponse`. Money fields are absent for a pure REPRESENTATIVE.
@freezed
abstract class Parcel with _$Parcel {
  const factory Parcel({
    required int id,
    String? barcode,
    @JsonKey(unknownEnumValue: ParcelSource.unknown) ParcelSource? source,
    @JsonKey(unknownEnumValue: ParcelStatus.unknown) ParcelStatus? status,
    DateTime? statusChangedAt,
    String? statusChangedBy,
    @Default(false) bool needsEnrichment,
    int? representativeId,
    String? representativeName,
    int? clientId,
    String? clientName,
    String? clientPhone,
    String? clientCity,
    String? clientAddress,
    String? description,
    double? weightKg,
    int? seatsAmount,
    double? lengthCm,
    double? widthCm,
    double? heightCm,
    String? deliveryCity,
    double? declaredValue,
    double? deliveryPrice,
    String? deliveryPriceCurrency,
    @JsonKey(unknownEnumValue: PaymentStatus.unknown)
    PaymentStatus? paymentStatus,
    DateTime? paidAt,
    String? paidBy,
    String? senderName,
    String? senderPhone,
    String? senderCity,
    String? notes,
    String? npTtn,
    String? npPreviousTtn,
    String? npStatusCode,
    @JsonKey(unknownEnumValue: NpState.unknown) NpState? npState,
    String? npStatusText,
    DateTime? npStatusUpdatedAt,
    String? npRecipientWarehouse,
    DateTime? npScheduledDeliveryAt,
    DateTime? npArrivedAt,
    DateTime? npPaidStorageFrom,
    double? npDeliveryCost,
    double? npCodAmount,
    String? npPayerType,
    String? npPaymentMethod,
    double? npPreviousDeliveryCost,
    double? npAmountToPay,
    double? npVolumeWeight,
    @Default([]) List<Seat> seats,
    int? warehouseId,
    String? warehouseName,
    int? plannedTripId,
    int? tripId,
    DateTime? createdAt,
  }) = _Parcel;
  const Parcel._();

  factory Parcel.fromJson(Map<String, dynamic> json) => _$ParcelFromJson(json);

  /// Barcode when assigned, else the TTN — what a human calls this parcel.
  String get code => barcode ?? npTtn ?? '#$id';

  int get seatCount => seats.isNotEmpty ? seats.length : (seatsAmount ?? 1);

  int seatsIn(ParcelStatus s) => seats.where((x) => x.status == s).length;

  /// Picked up at the branch per Nova Poshta, but our representative has not scanned it yet.
  bool get pickedUpNotScanned =>
      status == ParcelStatus.IN_NOVA_POSHTA && npState == NpState.RECEIVED;

  bool get hasPrice => deliveryPrice != null;
  bool get isPaid => paymentStatus == PaymentStatus.PAID;

  /// Paid storage at Nova Poshta already started (or starts today).
  bool get paidStorageDue {
    final from = npPaidStorageFrom;
    if (from == null) return false;
    final today = DateTime.now();
    return !from.isAfter(
      DateTime(today.year, today.month, today.day, 23, 59, 59),
    );
  }
}
