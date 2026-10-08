/// What a scanned/typed code refers to.
enum ScanCodeType {
  /// Nova Poshta waybill — 14 digits.
  ttn,

  /// Nova Poshta seat label — the 14-digit waybill plus a 4-digit seat number.
  ttnSeat,

  /// Our parcel barcode — `PT` + 10 digits.
  parcel,

  /// Seat label — `PT` + 10 digits + `-N`.
  seat,

  unknown,
}

final _ttn = RegExp(r'^\d{14}$');
final _ttnSeat = RegExp(r'^\d{18}$');
final _parcel = RegExp(r'^PT\d{10}$');
final _seat = RegExp(r'^PT\d{10}-\d+$');

/// Normalizes raw scanner/keyboard input: trims, uppercases, strips inner whitespace.
String normalizeScanCode(String raw) =>
    raw.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

ScanCodeType classifyScanCode(String code) {
  if (_ttn.hasMatch(code)) return ScanCodeType.ttn;
  if (_ttnSeat.hasMatch(code)) return ScanCodeType.ttnSeat;
  if (_parcel.hasMatch(code)) return ScanCodeType.parcel;
  if (_seat.hasMatch(code)) return ScanCodeType.seat;
  return ScanCodeType.unknown;
}

/// `PT1234567890-2` → `PT1234567890`; other codes unchanged.
String parcelCodeOf(String code) =>
    classifyScanCode(code) == ScanCodeType.seat ? code.split('-').first : code;

/// The waybill a Nova Poshta code carries, or null when it is not one. A seat label starts with its waybill.
String? ttnOf(String code) => switch (classifyScanCode(code)) {
  ScanCodeType.ttn => code,
  ScanCodeType.ttnSeat => code.substring(0, 14),
  _ => null,
};
