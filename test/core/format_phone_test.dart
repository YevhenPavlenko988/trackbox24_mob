import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/util/format.dart';

void main() {
  test('formats numbers of any country', () {
    expect(formatPhone('380675673384'), '+380 67 567 33 84');
    expect(formatPhone('48572522222'), startsWith('+48 '));
    expect(formatPhone('4915112345678'), startsWith('+49 '));
    expect(formatPhone('12125551234'), startsWith('+1 '));
    expect(formatPhone('12345'), '12345');
    expect(formatPhone(null), '—');
  });
}
