import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/util/scan_code.dart';

void main() {
  test('normalizes whitespace and case', () {
    expect(normalizeScanCode('  pt1234567890-2 \n'), 'PT1234567890-2');
    expect(normalizeScanCode('2045 1549 4540 07'), '20451549454007');
  });

  test('classifies codes', () {
    expect(classifyScanCode('20451549454007'), ScanCodeType.ttn);
    expect(classifyScanCode('PT1234567890'), ScanCodeType.parcel);
    expect(classifyScanCode('PT1234567890-12'), ScanCodeType.seat);
    expect(classifyScanCode('M104521'), ScanCodeType.parcel);
    expect(classifyScanCode('M104521-170'), ScanCodeType.seat);
    expect(classifyScanCode('M10452'), ScanCodeType.unknown);
    expect(classifyScanCode('PT123'), ScanCodeType.unknown);
    expect(classifyScanCode('2045154945400'), ScanCodeType.unknown);
    expect(classifyScanCode(''), ScanCodeType.unknown);
  });

  test('parcel code of a seat label', () {
    expect(parcelCodeOf('PT1234567890-3'), 'PT1234567890');
    expect(parcelCodeOf('PT1234567890'), 'PT1234567890');
    expect(parcelCodeOf('20451549454007'), '20451549454007');
    expect(parcelCodeOf('M104521-17'), 'M104521');
    expect(seatNumberOf('M104521-17'), 17);
    expect(seatNumberOf('M104521'), isNull);
  });
}
