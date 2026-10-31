import 'package:trackbox24_mob/features/parcels/data/parcel_model.dart';

/// One 70×40 mm tape label: our barcode of a seat (or of the whole parcel) and what the driver reads off it.
///
/// Nova Poshta's own 100×100 sticker does not fit the tape of a NIIMBOT B3S, so the label is drawn from the
/// parcel and carries both codes: our `PT…` barcode and, once it exists, our outgoing waybill.
class ParcelLabel {
  const ParcelLabel({
    required this.code,
    required this.total,
    this.seat,
    this.waybill,
    this.recipient,
    this.city,
    this.place,
    this.phone,
    this.weightKg,
    this.description,
    this.route,
    this.move = false,
  });

  /// `PT…` for a one-seat parcel, `PT…-N` for a seat.
  final String code;
  final int? seat;
  final int total;

  /// Our outgoing Nova Poshta waybill, the same on every seat of the parcel.
  final String? waybill;

  /// Who gets the parcel («Коваль І.»), or the client while nothing else is known.
  final String? recipient;
  final String? city;

  /// The branch or the street address the parcel goes to.
  final String? place;

  /// Digits as stored by the backend.
  final String? phone;
  final double? weightKg;

  /// What the item is, on a move's label.
  final String? description;

  /// A move's route: «Київ → Варшава» (either end may be unknown).
  final String? route;

  /// A move's item: its number and description on top instead of the recipient.
  final bool move;

  String get fileName => '${code.replaceAll(RegExp('[^A-Za-z0-9-]'), '_')}.png';
}

/// One label per seat; a parcel without seats yet gets one for its own barcode.
List<ParcelLabel> labelsFor(Parcel p) {
  final total = p.seatCount;
  final parts = _partsFor(p);
  ParcelLabel label(String code, int? seat, {String? description}) =>
      ParcelLabel(
        code: code,
        seat: seat,
        total: total,
        waybill: p.npShipment?.waybillNumber,
        recipient: parts.recipient,
        city: parts.city,
        place: parts.place,
        phone: parts.phone,
        weightKg: p.weightKg,
        description: description,
        move: p.isMove,
      );
  // A move: every item its own label with the route, the recipient and their phone and what it is, even an order
  // of one item.
  if (p.isMove) {
    return [
      for (final s in p.seats)
        if (s.barcode != null)
          ParcelLabel(
            code: s.barcode!,
            seat: s.seatNumber,
            total: total,
            recipient: _nonEmpty(p.clientName),
            phone: _nonEmpty(p.clientPhone),
            route: moveRoute(p),
            description: s.description,
            move: true,
          ),
    ];
  }
  // One seat: the parcel's own code, which every scan accepts for a one-seat parcel; no «-1» on the label.
  if (p.seats.length > 1) {
    return [
      for (final s in p.seats)
        if (s.barcode != null) label(s.barcode!, s.seatNumber),
    ];
  }
  final code = p.barcode ?? p.seats.singleOrNull?.barcode;
  return code == null ? const [] : [label(code, null)];
}

/// Who gets the parcel and where: the waybill's recipient once it exists, the client before that.
({String? recipient, String? city, String? place, String? phone}) _partsFor(
  Parcel p,
) {
  final s = p.npShipment;
  final recipient = s == null
      ? null
      : shortName(s.recipientLastName, s.recipientFirstName);
  if (s == null || recipient == null) {
    return (
      recipient: _nonEmpty(p.clientName),
      city: _nonEmpty(p.clientCity),
      place: null,
      phone: _nonEmpty(p.clientPhone),
    );
  }
  final place = s.deliveryType == NpDeliveryType.ADDRESS
      ? _nonEmpty(
          [
            s.streetName,
            s.building,
          ].where((x) => x != null && x.isNotEmpty).join(', '),
        )
      : shortWarehouse(s.warehouseName);
  return (
    recipient: recipient,
    city: _nonEmpty(s.cityName),
    place: place,
    phone: _nonEmpty(s.recipientPhone) ?? _nonEmpty(p.clientPhone),
  );
}

String? _nonEmpty(String? s) => s == null || s.trim().isEmpty ? null : s.trim();

/// "20451558819168" → "20 4515 5881 9168", the way Nova Poshta prints its numbers.
String groupWaybill(String number) {
  final digits = number.replaceAll(RegExp(r'\s+'), '');
  if (!RegExp(r'^\d{14}$').hasMatch(digits)) return number;
  return '${digits.substring(0, 2)} ${digits.substring(2, 6)} '
      '${digits.substring(6, 10)} ${digits.substring(10)}';
}

/// "Коваль", "Іван" → "Коваль І." — what fits on a 70 mm label next to the city.
String? shortName(String? last, String? first) {
  final l = last?.trim() ?? '';
  final f = first?.trim() ?? '';
  if (l.isEmpty) return f.isEmpty ? null : f;
  return f.isEmpty ? l : '$l ${f[0]}.';
}

/// "Відділення №1: вул. Пирогівський шлях, 135" → "Відд. №1"; a locker keeps its name; a pickup point
/// without a number ("Пункт приймання-видачі (до 30 кг): вул. Центральна, 1") is known by its address.
String? shortWarehouse(String? name) {
  if (name == null || name.trim().isEmpty) return null;
  final colon = name.indexOf(':');
  final head = (colon < 0 ? name : name.substring(0, colon))
      .replaceAll(RegExp(r'\s*\([^)]*\)'), '')
      .trim();
  // The building number stays on the line of its street when the label wraps.
  final address = colon < 0
      ? ''
      : name
            .substring(colon + 1)
            .trim()
            .replaceAllMapped(
              RegExp(r',\s+(\S{1,5})$'),
              (m) => ',\u00A0${m[1]}',
            );
  final short = head
      .replaceFirst(
        RegExp('^(Поштове |Вантажне )?відділення', caseSensitive: false),
        'Відд.',
      )
      .replaceFirst(
        RegExp('^Пункт приймання-видачі', caseSensitive: false),
        'Пункт',
      );
  return short.contains('№') || address.isEmpty ? short : '$short: $address';
}

/// Who gets the parcel and where, in one line — the same parts the label shows on separate lines.
String? destinationLine(Parcel p) {
  final l = _partsFor(p);
  final parts = [
    l.recipient,
    l.city,
    l.place,
  ].where((x) => x != null && x.isNotEmpty);
  return parts.isEmpty ? null : parts.join(', ');
}

/// «Київ → Варшава»: where a move is collected and where it goes; null when neither is known.
String? moveRoute(Parcel p) {
  final from = _nonEmpty(p.senderCity);
  final to = _nonEmpty(p.deliveryCity) ?? _nonEmpty(p.clientCity);
  if (from == null && to == null) return null;
  return '${from ?? '—'} → ${to ?? '—'}';
}
