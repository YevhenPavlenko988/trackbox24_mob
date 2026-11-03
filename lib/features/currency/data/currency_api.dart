import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

double? _num(Object? v) => v == null ? null : (v as num).toDouble();
DateTime? _time(Object? v) => v == null ? null : DateTime.parse(v as String);

/// What money can be in, in the order it is listed everywhere: euro, hryvnia, dollar, zloty («Курси валют»).
const moneyCurrencies = ['EUR', 'UAH', 'USD', 'PLN'];

/// A move's own currency: euro or hryvnia; with «Курси валют» also dollar and zloty.
List<String> moveCurrencies({required bool multi}) =>
    multi ? moneyCurrencies : const ['EUR', 'UAH'];

/// One foreign currency for the company: the bank's commercial rate and the company's own, in hryvnias.
class CurrencyRate {
  const CurrencyRate({
    required this.currency,
    this.bankBuy,
    this.bankSell,
    this.bankSourceLabel,
    this.bankAt,
    this.companyRate,
    this.companySetBy,
    this.companySetAt,
    this.rate,
    this.source,
  });

  factory CurrencyRate.fromJson(Map<String, dynamic> j) => CurrencyRate(
    currency: j['currency'] as String,
    bankBuy: _num(j['bankBuy']),
    bankSell: _num(j['bankSell']),
    bankSourceLabel: j['bankSourceLabel'] as String?,
    bankAt: _time(j['bankAt']),
    companyRate: _num(j['companyRate']),
    companySetBy: j['companySetBy'] as String?,
    companySetAt: _time(j['companySetAt']),
    rate: _num(j['rate']),
    source: j['source'] as String?,
  );

  final String currency;
  final double? bankBuy;
  final double? bankSell;

  /// «Monobank» or «ПриватБанк» when Monobank did not answer.
  final String? bankSourceLabel;
  final DateTime? bankAt;
  final double? companyRate;
  final String? companySetBy;
  final DateTime? companySetAt;

  /// What counts: the company's own rate, else the bank's buy.
  final double? rate;

  /// `COMPANY`, `MONOBANK` or `PRIVATBANK`.
  final String? source;
}

/// How many [to] one [from] is worth, through hryvnias at the company's rates; null without a rate.
double? convertRate(List<CurrencyRate>? rates, String from, String to) {
  if (from == to) return 1;
  double? toUah(String c) =>
      c == 'UAH' ? 1 : rates?.where((r) => r.currency == c).firstOrNull?.rate;
  final a = toUah(from);
  final b = toUah(to);
  return a == null || b == null || b == 0 ? null : a / b;
}

class CurrencyApi {
  CurrencyApi(this._dio);

  final Dio _dio;

  Future<List<CurrencyRate>> rates() async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/currency/rates');
      return [
        for (final r in res.data!)
          CurrencyRate.fromJson((r as Map).cast<String, dynamic>()),
      ];
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// The company's own rate: a manager or a representative; a driver only sees it.
  Future<void> setRate(String currency, double rate) async {
    try {
      await _dio.put<void>(
        '/api/currency/rates/$currency',
        data: {'rate': rate},
      );
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Back to the bank's rate.
  Future<void> resetRate(String currency) async {
    try {
      await _dio.delete<void>('/api/currency/rates/$currency');
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final currencyApiProvider = Provider<CurrencyApi>(
  (ref) => CurrencyApi(ref.watch(dioProvider)),
);

final ratesProvider = FutureProvider.autoDispose<List<CurrencyRate>>(
  (ref) => ref.watch(currencyApiProvider).rates(),
);
