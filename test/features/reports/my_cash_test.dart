import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/features/reports/data/reports_api.dart';

void main() {
  group('my cash', () {
    test('periods count from today; the week starts on Monday', () {
      final thursday = DateTime(2026, 11, 12, 15);
      expect(presetPeriod(CashPreset.today, thursday), (
        from: '2026-11-12',
        to: '2026-11-12',
      ));
      expect(presetPeriod(CashPreset.week, thursday), (
        from: '2026-11-09',
        to: '2026-11-12',
      ));
      expect(presetPeriod(CashPreset.month, thursday), (
        from: '2026-11-01',
        to: '2026-11-12',
      ));
      expect(presetPeriod(CashPreset.lastMonth, thursday), (
        from: '2026-10-01',
        to: '2026-10-31',
      ));
      // January's last month is December of the year before
      expect(presetPeriod(CashPreset.lastMonth, DateTime(2027, 1, 5)), (
        from: '2026-12-01',
        to: '2026-12-31',
      ));
    });

    test('reads the report', () {
      final r = CashReport.fromJson({
        'reportCurrency': 'EUR',
        'reportTotal': 40,
        'totals': [
          {'currency': 'EUR', 'method': 'CASH', 'amount': 30, 'count': 1},
          {'currency': 'UAH', 'method': null, 'amount': 500.5, 'count': 2},
        ],
        'onHand': [
          {'currency': 'EUR', 'taken': 30, 'handedOver': 20, 'onHand': 10},
        ],
        'handovers': [
          {
            'amount': 20,
            'currency': 'EUR',
            'handedAt': '2026-11-11T09:00:00Z',
            'receivedByName': 'Олена',
          },
        ],
        'entries': [
          {
            'at': '2026-11-10T10:00:00Z',
            'dateOnly': true,
            'kind': 'MOVE',
            'parcelId': 7,
            'code': 'M123456',
            'method': 'CASH',
            'amount': 30,
            'currency': 'EUR',
          },
        ],
      });
      expect(r.reportCurrency, 'EUR');
      expect(r.totals[1].method, isNull);
      expect(r.totals[1].amount, 500.5);
      expect(r.onHand.single.onHand, 10);
      expect(r.handovers.single.receivedByName, 'Олена');
      expect(r.entries.single.isMove, isTrue);
      expect(r.entries.single.dateOnly, isTrue);
    });

    test('reads the pay: rate, totals and lines', () {
      final p = MyPay.fromJson({
        'currency': 'EUR',
        'rate': {'currency': 'EUR', 'perTrip': 50, 'revenuePercent': 10},
        'opening': 0,
        'accrued': 74,
        'expenses': 15,
        'paid': 60,
        'closing': 29,
        'lines': [
          {
            'date': '2026-11-12',
            'kind': 'TRIP',
            'tripNumber': '14',
            'days': 1,
            'amount': 74,
            'currency': 'EUR',
            'balanceAmount': 74,
          },
          {
            'date': '2026-11-12',
            'kind': 'PAYOUT',
            'amount': 20,
            'currency': 'EUR',
            'balanceAmount': -20,
            'fromCollectedCash': true,
          },
        ],
      });
      expect(p.rate!.perTrip, 50);
      expect(p.rate!.perDay, isNull);
      expect(p.closing, 29);
      expect(p.lines.first.tripNumber, '14');
      expect(p.lines.last.balanceAmount, -20);
      expect(p.lines.last.fromCollectedCash, isTrue);
    });
  });
}
