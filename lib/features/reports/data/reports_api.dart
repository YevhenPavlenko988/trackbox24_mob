import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

double _num(Object? v) => v == null ? 0 : (v as num).toDouble();
double? _numOrNull(Object? v) => v == null ? null : (v as num).toDouble();
List<Map<String, dynamic>> _list(Object? v) => [
  for (final e in (v as List?) ?? const []) (e as Map).cast<String, dynamic>(),
];

/// Received in one currency by one method.
class CashSum {
  const CashSum({
    required this.currency,
    required this.amount,
    required this.count,
    this.method,
  });

  factory CashSum.fromJson(Map<String, dynamic> j) => CashSum(
    currency: j['currency'] as String,
    method: j['method'] as String?,
    amount: _num(j['amount']),
    count: (j['count'] as num?)?.toInt() ?? 0,
  );

  final String currency;

  /// `CASH`, `UA_CARD`, `FOREIGN_CARD`, `ONLINE`, `TRANSFER`; null — not given.
  final String? method;
  final double amount;
  final int count;
}

/// Cash in hand in one currency: taken in cash ever, less handed over to the office.
class CashOnHand {
  const CashOnHand({
    required this.currency,
    required this.taken,
    required this.handedOver,
    required this.onHand,
    this.spent = 0,
    this.paidOut = 0,
  });

  factory CashOnHand.fromJson(Map<String, dynamic> j) => CashOnHand(
    currency: j['currency'] as String,
    taken: _num(j['taken']),
    spent: _num(j['spent']),
    paidOut: _num(j['paidOut']),
    handedOver: _num(j['handedOver']),
    onHand: _num(j['onHand']),
  );

  final String currency;
  final double taken;

  /// Spent on trips out of the collected cash (fuel, roads…).
  final double spent;

  /// Kept out of the collected cash as pay.
  final double paidOut;
  final double handedOver;
  final double onHand;
}

/// Cash handed over to the office, recorded by the manager who took it.
class CashHandover {
  const CashHandover({
    required this.amount,
    required this.currency,
    this.handedAt,
    this.receivedByName,
    this.note,
  });

  factory CashHandover.fromJson(Map<String, dynamic> j) => CashHandover(
    amount: _num(j['amount']),
    currency: j['currency'] as String,
    handedAt: j['handedAt'] == null
        ? null
        : DateTime.parse(j['handedAt'] as String),
    receivedByName: j['receivedByName'] as String?,
    note: j['note'] as String?,
  );

  final double amount;
  final String currency;
  final DateTime? handedAt;
  final String? receivedByName;
  final String? note;
}

/// One payment taken: of a parcel or a move.
class CashEntry {
  const CashEntry({
    required this.isMove,
    required this.parcelId,
    required this.amount,
    required this.currency,
    this.at,
    this.dateOnly = false,
    this.code,
    this.clientName,
    this.method,
  });

  factory CashEntry.fromJson(Map<String, dynamic> j) => CashEntry(
    at: j['at'] == null ? null : DateTime.parse(j['at'] as String),
    dateOnly: j['dateOnly'] as bool? ?? false,
    isMove: j['kind'] == 'MOVE',
    parcelId: (j['parcelId'] as num).toInt(),
    code: j['code'] as String?,
    clientName: j['clientName'] as String?,
    method: j['method'] as String?,
    amount: _num(j['amount']),
    currency: j['currency'] as String,
  );

  final DateTime? at;

  /// Entered with a day only (a move's payment): show the date, not a time.
  final bool dateOnly;
  final bool isMove;
  final int parcelId;
  final String? code;
  final String? clientName;
  final String? method;
  final double amount;
  final String currency;
}

/// «Моя каса»: what the signed-in driver or representative took over the days, what is still in hand.
class CashReport {
  const CashReport({
    required this.reportCurrency,
    required this.totals,
    required this.onHand,
    required this.handovers,
    required this.entries,
    this.reportTotal,
  });

  factory CashReport.fromJson(Map<String, dynamic> j) => CashReport(
    reportCurrency: (j['reportCurrency'] as String?) ?? 'UAH',
    reportTotal: _numOrNull(j['reportTotal']),
    totals: [for (final e in _list(j['totals'])) CashSum.fromJson(e)],
    onHand: [for (final e in _list(j['onHand'])) CashOnHand.fromJson(e)],
    handovers: [
      for (final e in _list(j['handovers'])) CashHandover.fromJson(e),
    ],
    entries: [for (final e in _list(j['entries'])) CashEntry.fromJson(e)],
  );

  final String reportCurrency;
  final double? reportTotal;
  final List<CashSum> totals;
  final List<CashOnHand> onHand;
  final List<CashHandover> handovers;
  final List<CashEntry> entries;
}

/// How a driver is paid from [validFrom]: the parts that are set add up.
class PayRate {
  const PayRate({
    required this.currency,
    this.validFrom,
    this.perTrip,
    this.perKm,
    this.revenuePercent,
    this.perDay,
    this.monthly,
  });

  factory PayRate.fromJson(Map<String, dynamic> j) => PayRate(
    currency: j['currency'] as String,
    validFrom: j['validFrom'] as String?,
    perTrip: _numOrNull(j['perTrip']),
    perKm: _numOrNull(j['perKm']),
    revenuePercent: _numOrNull(j['revenuePercent']),
    perDay: _numOrNull(j['perDay']),
    monthly: _numOrNull(j['monthly']),
  );

  final String currency;
  final String? validFrom;
  final double? perTrip;
  final double? perKm;
  final double? revenuePercent;
  final double? perDay;
  final double? monthly;
}

/// One line of a driver's pay: a trip (`TRIP`), the monthly wage (`MONTHLY`), own money spent (`EXPENSE`), a payout.
class PayLine {
  const PayLine({
    required this.kind,
    required this.amount,
    required this.currency,
    required this.balanceAmount,
    this.date,
    this.tripNumber,
    this.label,
    this.noRate = false,
    this.km,
    this.days,
    this.monthDays,
    this.fromCollectedCash = false,
  });

  factory PayLine.fromJson(Map<String, dynamic> j) => PayLine(
    kind: j['kind'] as String,
    date: j['date'] == null ? null : DateTime.parse(j['date'] as String),
    tripNumber: j['tripNumber'] as String?,
    label: j['label'] as String?,
    noRate: j['noRate'] as bool? ?? false,
    km: (j['km'] as num?)?.toInt(),
    days: (j['days'] as num?)?.toInt(),
    monthDays: (j['monthDays'] as num?)?.toInt(),
    amount: _num(j['amount']),
    currency: j['currency'] as String,
    balanceAmount: _num(j['balanceAmount']),
    fromCollectedCash: j['fromCollectedCash'] as bool? ?? false,
  );

  final String kind;
  final DateTime? date;
  final String? tripNumber;
  final String? label;
  final bool noRate;
  final int? km;
  final int? days;
  final int? monthDays;
  final double amount;
  final String currency;

  /// In the settlement's currency: earned and own money spent are plus, paid is minus.
  final double balanceAmount;
  final bool fromCollectedCash;
}

/// «Мій заробіток»: what the driver earned, spent of their own and was paid over the days, and what is owed now.
class MyPay {
  const MyPay({
    required this.currency,
    required this.opening,
    required this.accrued,
    required this.expenses,
    required this.paid,
    required this.closing,
    required this.lines,
    this.rate,
  });

  factory MyPay.fromJson(Map<String, dynamic> j) => MyPay(
    currency: j['currency'] as String,
    rate: j['rate'] == null
        ? null
        : PayRate.fromJson((j['rate'] as Map).cast<String, dynamic>()),
    opening: _num(j['opening']),
    accrued: _num(j['accrued']),
    expenses: _num(j['expenses']),
    paid: _num(j['paid']),
    closing: _num(j['closing']),
    lines: [for (final e in _list(j['lines'])) PayLine.fromJson(e)],
  );

  final String currency;
  final PayRate? rate;
  final double opening;
  final double accrued;
  final double expenses;
  final double paid;

  /// Plus — the company owes the driver; minus — paid more than earned.
  final double closing;
  final List<PayLine> lines;
}

/// Days of a report, both included: `2026-11-01`.
typedef CashPeriod = ({String from, String to});

enum CashPreset { today, week, month, lastMonth }

String _iso(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// The days of a preset counted from [now]; the week starts on Monday.
CashPeriod presetPeriod(CashPreset preset, [DateTime? now]) {
  final n = now ?? DateTime.now();
  final today = DateTime(n.year, n.month, n.day);
  return switch (preset) {
    CashPreset.today => (from: _iso(today), to: _iso(today)),
    CashPreset.week => (
      from: _iso(today.subtract(Duration(days: today.weekday - 1))),
      to: _iso(today),
    ),
    CashPreset.month => (
      from: _iso(DateTime(today.year, today.month)),
      to: _iso(today),
    ),
    CashPreset.lastMonth => (
      from: _iso(DateTime(today.year, today.month - 1)),
      to: _iso(DateTime(today.year, today.month, 0)),
    ),
  };
}

class ReportsApi {
  ReportsApi(this._dio);

  final Dio _dio;

  /// The signed-in person's own cash: the backend shows a driver or representative only theirs.
  Future<CashReport> myCash(CashPeriod period) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/reports/cash',
        queryParameters: {'from': period.from, 'to': period.to},
      );
      return CashReport.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// The signed-in driver's own settlement; nothing when the company has none for them.
  Future<MyPay?> myPay(CashPeriod period) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/reports/drivers',
        queryParameters: {'from': period.from, 'to': period.to},
      );
      final drivers = _list(res.data!['drivers']);
      return drivers.isEmpty ? null : MyPay.fromJson(drivers.first);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final reportsApiProvider = Provider<ReportsApi>(
  (ref) => ReportsApi(ref.watch(dioProvider)),
);

final myCashProvider = FutureProvider.autoDispose
    .family<CashReport, CashPeriod>(
      (ref, period) => ref.watch(reportsApiProvider).myCash(period),
    );

final myPayProvider = FutureProvider.autoDispose.family<MyPay?, CashPeriod>(
  (ref, period) => ref.watch(reportsApiProvider).myPay(period),
);
