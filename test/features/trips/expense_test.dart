import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/reports/data/reports_api.dart';
import 'package:trackbox24_mob/features/trips/data/expense_api.dart';

void main() {
  test('reads an expense of a trip', () {
    final e = TripExpense.fromJson({
      'id': 12,
      'kind': 'FUEL',
      'kindLabel': 'Пальне',
      'amount': 85.4,
      'currency': 'EUR',
      'paidFrom': 'COLLECTED_CASH',
      'spentAt': '2026-11-12T08:30:00Z',
      'receiptThumbUrl': 'https://s3/x-thumb.webp',
      'editable': true,
    });
    expect(e.amount, 85.4);
    expect(e.paidFrom, 'COLLECTED_CASH');
    expect(e.editable, isTrue);
    expect(e.receiptThumbUrl, isNotNull);
    expect(expenseKinds.first, 'FUEL');
  });

  test('cash in hand carries what was spent on trips', () {
    final h = CashOnHand.fromJson({
      'currency': 'EUR',
      'taken': 30,
      'spent': 20,
      'handedOver': 0,
      'onHand': 10,
    });
    expect(h.spent, 20);
    expect(h.onHand, 10);
  });
}
