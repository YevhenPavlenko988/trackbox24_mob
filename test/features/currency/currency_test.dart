import 'package:flutter_test/flutter_test.dart';
import 'package:trackbox24_mob/core/util/format.dart';
import 'package:trackbox24_mob/features/currency/data/currency_api.dart';
import 'package:trackbox24_mob/features/moves/data/move_bill.dart';

void main() {
  const rates = [
    CurrencyRate(currency: 'USD', rate: 45),
    CurrencyRate(currency: 'EUR', rate: 50),
    CurrencyRate(currency: 'PLN'),
  ];

  test('rates convert through hryvnias', () {
    expect(convertRate(rates, 'USD', 'EUR'), closeTo(0.9, 1e-9));
    expect(convertRate(rates, 'EUR', 'UAH'), 50);
    expect(convertRate(rates, 'UAH', 'UAH'), 1);
    // no rate yet — nothing to show
    expect(convertRate(rates, 'PLN', 'EUR'), isNull);
    expect(convertRate(null, 'USD', 'EUR'), isNull);
  });

  test('euro, hryvnia, dollar, zloty; a move gets the last two only with the module', () {
    expect(moneyCurrencies, ['EUR', 'UAH', 'USD', 'PLN']);
    expect(priceCurrencies(multi: false), ['EUR', 'UAH']);
    expect(priceCurrencies(multi: true), moneyCurrencies);
  });

  test('a foreign card pays in anything but hryvnias; a Ukrainian card in hryvnias by default', () {
    expect(paidCurrencies('FOREIGN_CARD'), ['EUR', 'USD', 'PLN']);
    expect(paidCurrencies('CASH'), moneyCurrencies);
    expect(defaultPaidCurrency('UA_CARD', 'EUR'), 'UAH');
    expect(defaultPaidCurrency('CASH', 'EUR'), 'EUR');
    expect(defaultPaidCurrency('FOREIGN_CARD', 'UAH'), 'EUR');
    expect(defaultPaidCurrency('FOREIGN_CARD', 'USD'), 'USD');
  });

  test('money of every currency has its sign', () {
    expect(currencySymbol('USD'), r'$');
    expect(currencySymbol('PLN'), 'zł');
    expect(currencySymbol('EUR'), '€');
    expect(currencySymbol('UAH'), 'грн');
    expect(formatMoney(200, 'USD'), endsWith(r' $'));
  });

  test('a payment in dollars keeps what the client gave', () {
    final bill = MoveBill.fromJson({
      'currency': 'USD',
      'baseCurrency': 'EUR',
      'conversionRate': 1.1183,
      'payments': [
        {'id': 1, 'amount': 180, 'paidCurrency': 'USD', 'paidAmount': 200},
        {'id': 2, 'amount': 20},
      ],
    });
    expect(bill.baseCurrency, 'EUR');
    expect(bill.conversionRate, 1.1183);
    expect(bill.payments.first.paidCurrency, 'USD');
    expect(bill.payments.first.paidAmount, 200);
    expect(bill.payments.last.paidCurrency, isNull);
  });

  test('a rate from the backend', () {
    final r = CurrencyRate.fromJson({
      'currency': 'USD',
      'bankBuy': 45.66,
      'bankSell': 46.0596,
      'bankSourceLabel': 'Monobank',
      'bankAt': '2026-11-03T15:21:00Z',
      'rate': 46.5,
      'source': 'COMPANY',
      'companySetBy': 'rep Test',
    });
    expect(r.rate, 46.5);
    expect(r.source, 'COMPANY');
    expect(r.bankAt, isNotNull);
  });
}
