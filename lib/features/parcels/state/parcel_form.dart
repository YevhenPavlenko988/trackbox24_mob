import 'package:trackbox24_mob/core/model/channel.dart';
import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// Text-field values of the parcel form (strings, as typed) plus the client.
class ParcelFormValues {
  const ParcelFormValues({
    this.description = '',
    this.seatsAmount = '1',
    this.weightKg = '',
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
  final String declaredValue;
  final String senderName;
  final String senderPhone;
  final String senderCity;
  final String notes;
  final bool needsEnrichment;
  final int? clientId;
  final Channel? channel;
  final String channelDetails;

  static String _num(num? v) =>
      v == null ? '' : (v == v.roundToDouble() ? '${v.toInt()}' : '$v');
}

/// Seats can be changed only while no seat has been loaded into a car.
bool canEditSeatsAmount(Parcel p) {
  bool unloaded(ParcelStatus? s) =>
      s == ParcelStatus.IN_NOVA_POSHTA ||
      s == ParcelStatus.PICKED_UP_FROM_NOVA_POSHTA ||
      s == ParcelStatus.RECEIVED_BY_REPRESENTATIVE ||
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
Map<String, dynamic> createBody(
  ParcelFormValues v, {
  String? npTtn,
  bool alreadyReceived = false,
}) {
  return {
    if (npTtn != null && npTtn.isNotEmpty) 'npTtn': npTtn,
    if (npTtn != null && npTtn.isNotEmpty) 'alreadyReceived': alreadyReceived,
    if (v.clientId != null) 'clientId': v.clientId,
    if (_orNull(v.description) != null) 'description': _orNull(v.description),
    if (parseNum(v.weightKg) != null) 'weightKg': parseNum(v.weightKg),
    if (parseNum(v.seatsAmount) != null) 'seatsAmount': parseNum(v.seatsAmount),
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
