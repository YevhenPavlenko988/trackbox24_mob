import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/nova_poshta/data/np_directory_api.dart';
import 'package:trackbox24_mob/features/nova_poshta/ui/np_ref_picker.dart';

void main() {
  test('a branch carries the weight limit Nova Poshta gives it', () {
    final small = NpBranch.fromJson({'ref': 'a', 'maxWeightKg': 10});
    final seat = NpBranch.fromJson({'ref': 'b', 'maxSeatWeightKg': 30});
    const free = NpBranch(ref: 'c');

    expect(small.tooHeavy(12, 1), isTrue);
    expect(small.tooHeavy(10, 3), isFalse);
    expect(small.tooHeavy(null, 1), isFalse);
    // a per-seat limit says nothing about the weight of several seats together
    expect(seat.tooHeavy(40, 1), isTrue);
    expect(seat.tooHeavy(40, 2), isFalse);
    expect(free.tooHeavy(500, 1), isFalse);
  });

  test('kilograms read as people write them', () {
    expect(npKg(10), '10');
    expect(npKg(2.5), '2.5');
  });
}
