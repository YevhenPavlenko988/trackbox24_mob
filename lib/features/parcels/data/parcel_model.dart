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

  /// Handed over to Nova Poshta with our own waybill (return parcels); delivered when the recipient picks it up.
  SENT_VIA_NOVA_POSHTA,
  DELIVERED_TO_CLIENT,
  CANCELLED,
  unknown,
}

enum PaymentStatus { UNPAID, PAID, unknown }

/// How our delivery was paid; picking one at hand-over also means the money was taken.
enum PaymentMethod { CASH, UA_CARD, FOREIGN_CARD, unknown }

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

/// Where Nova Poshta takes an outgoing parcel of ours.
enum NpDeliveryType { WAREHOUSE, POSTOMAT, ADDRESS, unknown }

enum NpCargoType { PARCEL, DOCUMENTS, CARGO, unknown }

/// Who pays Nova Poshta for our outgoing waybill.
enum NpPayerType { SENDER, RECIPIENT, unknown }

/// How that payment is made; unrelated to [PaymentMethod], which is about our own delivery price.
enum NpPaymentMethod { CASH, NON_CASH, unknown }

/// Our outgoing Nova Poshta shipment of a parcel (return parcels): the recipient, where it goes, and our waybill.
@freezed
abstract class NpShipment with _$NpShipment {
  const factory NpShipment({
    String? recipientLastName,
    String? recipientFirstName,
    String? recipientMiddleName,
    String? recipientPhone,
    @JsonKey(unknownEnumValue: NpDeliveryType.unknown)
    NpDeliveryType? deliveryType,
    String? cityRef,
    String? cityName,
    String? warehouseRef,
    String? warehouseName,
    String? streetRef,
    String? streetName,
    String? building,
    String? flat,
    @JsonKey(unknownEnumValue: NpCargoType.unknown) NpCargoType? cargoType,
    @JsonKey(unknownEnumValue: NpPayerType.unknown) NpPayerType? payerType,
    @JsonKey(unknownEnumValue: NpPaymentMethod.unknown)
    NpPaymentMethod? paymentMethod,
    double? codAmount,
    String? waybillNumber,
    DateTime? waybillCreatedAt,
    double? waybillCost,
    /// Dispatch date written into the waybill: the parcel's trip arrives, plus a day.
    DateTime? shipDate,
    DateTime? estimatedDeliveryDate,
    String? npStatusCode,
    @JsonKey(unknownEnumValue: NpState.unknown) NpState? npState,
    String? npStatusText,
    DateTime? npStatusUpdatedAt,
  }) = _NpShipment;
  const NpShipment._();

  factory NpShipment.fromJson(Map<String, dynamic> json) =>
      _$NpShipmentFromJson(json);

  bool get hasWaybill => waybillNumber != null;

  /// Nova Poshta has not taken the parcel yet, so the waybill can still be deleted (by the driver or a manager).
  bool get waybillDeletable =>
      hasWaybill && (npState == null || npState == NpState.CREATED);

  String? get recipientName {
    final parts = [recipientLastName, recipientFirstName, recipientMiddleName]
        .where((s) => s != null && s.isNotEmpty);
    return parts.isEmpty ? null : parts.join(' ');
  }

  /// City plus branch, locker or street address — one line, as a human would say it.
  String? get destination {
    final toAddress = deliveryType == NpDeliveryType.ADDRESS;
    final address = [
      streetName,
      building,
      if (flat != null && flat!.isNotEmpty) 'кв. $flat',
    ].where((s) => s != null && s.isNotEmpty).join(', ');
    final where = toAddress ? address : warehouseName ?? '';
    final parts = [
      cityName,
      if (where.isNotEmpty) where,
    ].where((s) => s != null && s.isNotEmpty);
    return parts.isEmpty ? null : parts.join(' · ');
  }
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
    @JsonKey(unknownEnumValue: PaymentMethod.unknown)
    PaymentMethod? paymentMethod,
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

    /// Nova Poshta's own view of the delivery payment, e.g. `Payed` when it was paid online before pickup.
    String? npPaymentStatus,
    double? npDeliveryAmountDue,
    double? npPreviousDeliveryCost,
    double? npAmountToPay,

    /// The parts of [npAmountToPay], as the backend computes them; they always add up to it.
    double? npDeliveryToPay,
    double? npPreviousDeliveryToPay,
    double? npCodToPay,
    double? npVolumeWeight,
    @Default([]) List<Seat> seats,
    NpShipment? npShipment,
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

  /// Redirected, returning or lost: nothing to collect and nothing to scan, someone has to sort it out.
  bool get npProblem {
    final s = effectiveNpState;
    return s == NpState.REDIRECTED ||
        s == NpState.RETURNING ||
        s == NpState.NOT_FOUND;
  }

  /// Still to be scanned by the representative: either at the branch or already collected.
  bool get awaitsReceiveScan =>
      status == ParcelStatus.IN_NOVA_POSHTA ||
      status == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA;

  /// The parcel is still with us, so its outgoing shipment can be filled in and a waybill created.
  bool get withUs =>
      status == ParcelStatus.RECEIVED_BY_REPRESENTATIVE ||
      status == ParcelStatus.AT_WAREHOUSE ||
      status == ParcelStatus.IN_CAR;

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
