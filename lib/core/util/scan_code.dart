/// What a scanned/typed code refers to.
enum ScanCodeType {
  /// Nova Poshta TTN — 14 digits.
  ttn,

  /// Our parcel barcode — `PT` + 10 digits.
  parcel,

  /// Seat label — `PT` + 10 digits + `-N`.
  seat,

  unknown,
}

final _ttn = RegExp(r'^\d{14}$');
final _parcel = RegExp(r'^PT\d{10}$');
final _seat = RegExp(r'^PT\d{10}-\d+$');

/// Normalizes raw scanner/keyboard input: trims, uppercases, strips inner whitespace.
String normalizeScanCode(String raw) =>
    raw.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');

ScanCodeType classifyScanCode(String code) {
  if (_ttn.hasMatch(code)) return ScanCodeType.ttn;
  if (_parcel.hasMatch(code)) return ScanCodeType.parcel;
  if (_seat.hasMatch(code)) return ScanCodeType.seat;
  return ScanCodeType.unknown;
}

/// `PT1234567890-2` → `PT1234567890`; other codes unchanged.
String parcelCodeOf(String code) =>
    classifyScanCode(code) == ScanCodeType.seat ? code.split('-').first : code;
