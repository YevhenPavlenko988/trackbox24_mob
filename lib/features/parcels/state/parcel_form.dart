import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Text-field values of the parcel form (strings, as typed) plus the client.
class ParcelFormValues {
  const ParcelFormValues({
    this.description = '',
    this.seatsAmount = '1',
    this.weightKg = '',
    this.lengthCm = '',
    this.widthCm = '',
    this.heightCm = '',
    this.declaredValue = '',
    this.senderName = '',
    this.senderPhone = '',
    this.senderCity = '',
    this.notes = '',
    this.needsEnrichment = false,
    this.clientId,
    this.channel,
    this.channelDetails = '',
  });

  factory ParcelFormValues.fromParcel(Parcel? p) {
    if (p == null) return const ParcelFormValues();
    return ParcelFormValues(
      description: p.description ?? '',
      seatsAmount: '${p.seatCount}',
      weightKg: _num(p.weightKg),
      lengthCm: _num(p.lengthCm),
      widthCm: _num(p.widthCm),
      heightCm: _num(p.heightCm),
      declaredValue: _num(p.declaredValue),
      senderName: p.senderName ?? '',
      senderPhone: p.senderPhone ?? '',
      senderCity: p.senderCity ?? '',
      notes: p.notes ?? '',
      needsEnrichment: p.needsEnrichment,
      clientId: p.clientId,
      channel: p.channel == Channel.unknown ? null : p.channel,
      channelDetails: p.channelDetails ?? '',
    );
  }

  final String description;
  final String seatsAmount;
  final String weightKg;

  /// Nova Poshta charges an outgoing waybill by volume as well, so the driver measures the parcel on acceptance.
  final String lengthCm;
  final String widthCm;
  final String heightCm;
  final String declaredValue;
  final String senderName;
  final String senderPhone;
  final String senderCity;
  final String notes;
  final bool needsEnrichment;
  final int? clientId;
  final Channel? channel;
  final String channelDetails;

  /// A number as the form shows it: integers without a trailing «.0».
  static String numText(num? v) => _num(v);

  static String _num(num? v) =>
      v == null ? '' : (v == v.roundToDouble() ? '${v.toInt()}' : '$v');
}

/// Seats can be changed only while no seat has been loaded into a car.
bool canEditSeatsAmount(Parcel p) {
  bool unloaded(ParcelStatus? s) =>
      s == ParcelStatus.IN_NOVA_POSHTA ||
      s == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA ||
      s == ParcelStatus.RECEIVED_BY_REPRESENTATIVE ||
      s == ParcelStatus.ACCEPTED_BY_DRIVER ||
      s == ParcelStatus.AT_WAREHOUSE;
  if (p.seats.isEmpty) return unloaded(p.status);
  return p.seats.every((s) => unloaded(s.status));
}

num? parseNum(String s) {
  final t = s.trim().replaceAll(',', '.');
  if (t.isEmpty) return null;
  final i = int.tryParse(t);
  return i ?? double.tryParse(t);
}

String? _orNull(String s) => s.trim().isEmpty ? null : s.trim();

/// `POST /api/parcels` body: empty strings are omitted.
/// A driver accepting a parcel in person agrees the delivery price on the spot; representatives may not send it.
/// [paymentMethod] says the sender paid that price right there: the parcel is created already paid.
/// It needs a price, so without one it stays home rather than earning a 400.
Map<String, dynamic> createBody(
  ParcelFormValues v, {
  String? npTtn,
  bool alreadyReceived = false,
  String deliveryPrice = '',
  String deliveryPriceCurrency = 'UAH',
  PaymentMethod? paymentMethod,
}) {
  final price = parseNum(deliveryPrice);
  return {
    if (npTtn != null && npTtn.isNotEmpty) 'npTtn': npTtn,
    if (npTtn != null && npTtn.isNotEmpty) 'alreadyReceived': alreadyReceived,
    if (price != null) 'deliveryPrice': price,
    if (price != null) 'deliveryPriceCurrency': deliveryPriceCurrency,
    if (price != null && paymentMethod != null)
      'paymentMethod': paymentMethod.name,
    if (v.clientId != null) 'clientId': v.clientId,
    if (_orNull(v.description) != null) 'description': _orNull(v.description),
    if (parseNum(v.weightKg) != null) 'weightKg': parseNum(v.weightKg),
    if (parseNum(v.seatsAmount) != null) 'seatsAmount': parseNum(v.seatsAmount),
    if (parseNum(v.lengthCm) != null) 'lengthCm': parseNum(v.lengthCm),
    if (parseNum(v.widthCm) != null) 'widthCm': parseNum(v.widthCm),
    if (parseNum(v.heightCm) != null) 'heightCm': parseNum(v.heightCm),
    if (parseNum(v.declaredValue) != null)
      'declaredValue': parseNum(v.declaredValue),
    if (_orNull(v.senderName) != null) 'senderName': _orNull(v.senderName),
    if (_orNull(v.senderPhone) != null) 'senderPhone': _orNull(v.senderPhone),
    if (_orNull(v.senderCity) != null) 'senderCity': _orNull(v.senderCity),
    if (_orNull(v.notes) != null) 'notes': _orNull(v.notes),
    if (v.channel != null) 'channel': v.channel!.name,
    if (v.channel != null && _orNull(v.channelDetails) != null)
      'channelDetails': _orNull(v.channelDetails),
  };
}

/// `PUT /api/parcels/{id}` is partial and cannot clear a field, so only changed, non-empty values are sent.
Map<String, dynamic> updateBody(
  ParcelFormValues before,
  ParcelFormValues after,
) {
  final body = <String, dynamic>{};
  void text(String key, String a, String b) {
    if (a.trim() != b.trim() && _orNull(b) != null) body[key] = _orNull(b);
  }

  void number(String key, String a, String b) {
    if (parseNum(a) != parseNum(b) && parseNum(b) != null) {
      body[key] = parseNum(b);
    }
  }

  text('description', before.description, after.description);
  number('seatsAmount', before.seatsAmount, after.seatsAmount);
  number('weightKg', before.weightKg, after.weightKg);
  number('lengthCm', before.lengthCm, after.lengthCm);
  number('widthCm', before.widthCm, after.widthCm);
  number('heightCm', before.heightCm, after.heightCm);
  number('declaredValue', before.declaredValue, after.declaredValue);
  text('senderName', before.senderName, after.senderName);
  text('senderPhone', before.senderPhone, after.senderPhone);
  text('senderCity', before.senderCity, after.senderCity);
  text('notes', before.notes, after.notes);
  if (before.needsEnrichment != after.needsEnrichment) {
    body['needsEnrichment'] = after.needsEnrichment;
  }
  if (before.clientId != after.clientId && after.clientId != null) {
    body['clientId'] = after.clientId;
  }
  // PUT is partial: a cleared channel cannot be removed, only replaced.
  if (after.channel != null &&
      (before.channel != after.channel ||
          before.channelDetails.trim() != after.channelDetails.trim())) {
    body['channel'] = after.channel!.name;
    if (_orNull(after.channelDetails) != null) {
      body['channelDetails'] = _orNull(after.channelDetails);
    }
  }
  return body;
}
