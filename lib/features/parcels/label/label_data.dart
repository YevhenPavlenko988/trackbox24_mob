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
    this.line,
    this.weightKg,
  });

  /// `PT…` for a one-seat parcel, `PT…-N` for a seat.
  final String code;
  final int? seat;
  final int total;

  /// Our outgoing Nova Poshta waybill, the same on every seat of the parcel.
  final String? waybill;

  /// Who gets the parcel and where — one line.
  final String? line;
  final double? weightKg;

  String get fileName => '${code.replaceAll(RegExp('[^A-Za-z0-9-]'), '_')}.png';
}

/// One label per seat; a parcel without seats yet gets one for its own barcode.
List<ParcelLabel> labelsFor(Parcel p) {
  final total = p.seatCount;
  final waybill = p.npShipment?.waybillNumber;
  final line = destinationLine(p);
  ParcelLabel label(String code, int? seat) => ParcelLabel(
    code: code,
    seat: seat,
    total: total,
    waybill: waybill,
    line: line,
    weightKg: p.weightKg,
  );
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

/// The middle line of the label: who gets the parcel and where, or the client while nothing else is known.
String? destinationLine(Parcel p) {
  final s = p.npShipment;
  if (s != null) {
    final where = s.deliveryType == NpDeliveryType.ADDRESS
        ? [
            s.streetName,
            s.building,
          ].where((x) => x != null && x.isNotEmpty).join(', ')
        : shortWarehouse(s.warehouseName);
    final parts = [
      shortName(s.recipientLastName, s.recipientFirstName),
      s.cityName,
      where,
    ].where((x) => x != null && x.isNotEmpty);
    if (parts.isNotEmpty) return parts.join(', ');
  }
  final client = [
    p.clientName,
    p.clientCity,
  ].where((x) => x != null && x.isNotEmpty);
  return client.isEmpty ? null : client.join(', ');
}
