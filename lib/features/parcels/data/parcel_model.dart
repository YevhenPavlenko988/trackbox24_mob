import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:trackbox24_mob/core/model/channel.dart';

part 'parcel_model.freezed.dart';
part 'parcel_model.g.dart';

enum ParcelStatus {
  IN_NOVA_POSHTA,

  /// «У нас»: Nova Poshta reports the parcel as collected, the representative has not scanned it yet.
  PICKED_UP_FROM_NOVA_POSHTA,
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

/// Nova Poshta status codes (TrackingDocument StatusCode) → [NpState], mirror of the backend grouping.
/// Lets the app parse `npStatusCode` itself when `npState` is missing or unknown.
const npStateByCode = <String, NpState>{
  '1': NpState.CREATED,
  '2': NpState.NOT_FOUND,
  '3': NpState.NOT_FOUND,
  '4': NpState.IN_TRANSIT,
  '41': NpState.IN_TRANSIT,
  '5': NpState.IN_TRANSIT,
  '6': NpState.IN_TRANSIT,
  '12': NpState.IN_TRANSIT,
  '101': NpState.IN_TRANSIT,
  '112': NpState.IN_TRANSIT,
  '7': NpState.ARRIVED,
  '8': NpState.ARRIVED,
  '9': NpState.RECEIVED,
  '10': NpState.RECEIVED,
  '11': NpState.RECEIVED,
  '106': NpState.RECEIVED,
  '104': NpState.REDIRECTED,
  '102': NpState.RETURNING,
  '103': NpState.RETURNING,
  '105': NpState.RETURNING,
  '108': NpState.RETURNING,
  '111': NpState.DELIVERY_FAILED,
};

/// States in which the parcel is still on its way to (or waiting at) the branch.
const npLiveStates = {
  NpState.CREATED,
  NpState.IN_TRANSIT,
  NpState.ARRIVED,
  NpState.DELIVERY_FAILED,
  NpState.OTHER,
};

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
    @JsonKey(unknownEnumValue: Channel.unknown) Channel? channel,
    String? channelDetails,
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

  /// Backend `npState` when present, else parsed from `npStatusCode`; null when there is no NP status at all.
  NpState? get effectiveNpState {
    if (npState != null && npState != NpState.unknown) return npState;
    final code = npStatusCode;
    if (code == null) return null;
    return npStateByCode[code] ?? NpState.OTHER;
  }

  /// Nova Poshta already closed this waybill (picked up, redirected, returning, deleted): nothing to pick up.
  bool get goneFromNp {
    final s = effectiveNpState;
    return s != null && !npLiveStates.contains(s);
  }

  /// Still to be scanned by the representative: either at the branch or already collected.
  bool get awaitsReceiveScan =>
      status == ParcelStatus.IN_NOVA_POSHTA ||
      status == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA;

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
