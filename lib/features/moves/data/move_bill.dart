import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

double? _num(Object? v) => v == null ? null : (v as num).toDouble();
DateTime? _time(Object? v) => v == null ? null : DateTime.parse(v as String);

/// A loader of the company's directory.
class Loader {
  const Loader({required this.id, required this.fullName, this.phone});

  factory Loader.fromJson(Map<String, dynamic> j) => Loader(
    id: j['id'] as int,
    fullName: j['fullName'] as String? ?? j['firstName'] as String? ?? '',
    phone: j['phone'] as String?,
  );

  final int id;
  final String fullName;
  final String? phone;
}

/// A move's money as the backend computes it: the client's side and the loaders'.
class MoveBill {
  const MoveBill({
    required this.currency,
    required this.works,
    required this.storages,
    required this.payments,
    this.transport,
    this.loadersTotal,
    this.storageTotal,
    this.total,
    this.paid,
    this.due,
    this.loaderPayout,
    this.loaderPaid,
  });

  factory MoveBill.fromJson(Map<String, dynamic> j) => MoveBill(
    currency: j['currency'] as String? ?? 'EUR',
    transport: _num(j['transport']),
    works: [
      for (final w in (j['works'] as List? ?? const []))
        BillWork.fromJson((w as Map).cast<String, dynamic>()),
    ],
    storages: [
      for (final s in (j['storages'] as List? ?? const []))
        BillStorage.fromJson((s as Map).cast<String, dynamic>()),
    ],
    payments: [
      for (final p in (j['payments'] as List? ?? const []))
        BillPayment.fromJson((p as Map).cast<String, dynamic>()),
    ],
    loadersTotal: _num(j['loadersTotal']),
    storageTotal: _num(j['storageTotal']),
    total: _num(j['total']),
    paid: _num(j['paid']),
    due: _num(j['due']),
    loaderPayout: _num(j['loaderPayout']),
    loaderPaid: _num(j['loaderPaid']),
  );

  final String currency;
  final double? transport;
  final List<BillWork> works;
  final List<BillStorage> storages;
  final List<BillPayment> payments;
  final double? loadersTotal;
  final double? storageTotal;
  final double? total;
  final double? paid;
  final double? due;
  final double? loaderPayout;
  final double? loaderPaid;
}

class BillWork {
  const BillWork({
    required this.id,
    required this.kind,
    required this.kindLabel,
    required this.loaders,
    this.plannedAt,
    this.plannedHours,
    this.clientRate,
    this.loaderRate,
    this.notes,
    this.clientAmount,
    this.loaderAmount,
  });

  factory BillWork.fromJson(Map<String, dynamic> j) => BillWork(
    id: j['id'] as int,
    kind: j['kind'] as String? ?? 'LOAD',
    kindLabel: j['kindLabel'] as String? ?? '',
    plannedAt: _time(j['plannedAt']),
    plannedHours: _num(j['plannedHours']),
    clientRate: _num(j['clientRate']),
    loaderRate: _num(j['loaderRate']),
    notes: j['notes'] as String?,
    loaders: [
      for (final l in (j['loaders'] as List? ?? const []))
        BillWorkLoader.fromJson((l as Map).cast<String, dynamic>()),
    ],
    clientAmount: _num(j['clientAmount']),
    loaderAmount: _num(j['loaderAmount']),
  );

  final int id;

  /// `LOAD` or `UNLOAD`.
  final String kind;
  final String kindLabel;
  final DateTime? plannedAt;
  final double? plannedHours;
  final double? clientRate;
  final double? loaderRate;
  final String? notes;
  final List<BillWorkLoader> loaders;
  final double? clientAmount;
  final double? loaderAmount;
}

class BillWorkLoader {
  const BillWorkLoader({
    required this.loaderId,
    required this.name,
    required this.paid,
    this.phone,
    this.actualHours,
    this.hours,
    this.clientAmount,
    this.loaderAmount,
  });

  factory BillWorkLoader.fromJson(Map<String, dynamic> j) => BillWorkLoader(
    loaderId: j['loaderId'] as int,
    name: j['name'] as String? ?? '',
    phone: j['phone'] as String?,
    actualHours: _num(j['actualHours']),
    hours: _num(j['hours']),
    clientAmount: _num(j['clientAmount']),
    loaderAmount: _num(j['loaderAmount']),
    paid: j['paid'] as bool? ?? false,
  );

  final int loaderId;
  final String name;
  final String? phone;
  final double? actualHours;

  /// What the sums count: the actual hours, or the planned ones meanwhile.
  final double? hours;
  final double? clientAmount;
  final double? loaderAmount;
  final bool paid;
}

class BillStorage {
  const BillStorage({
    required this.id,
    this.warehouseName,
    this.days,
    this.rate,
    this.amount,
    this.notes,
  });

  factory BillStorage.fromJson(Map<String, dynamic> j) => BillStorage(
    id: j['id'] as int,
    warehouseName: j['warehouseName'] as String?,
    days: _num(j['days']),
    rate: _num(j['rate']),
    amount: _num(j['amount']),
    notes: j['notes'] as String?,
  );

  final int id;
  final String? warehouseName;
  final double? days;
  final double? rate;
  final double? amount;
  final String? notes;
}

class BillPayment {
  const BillPayment({
    this.id,
    this.amount,
    this.methodLabel,
    this.paidOn,
    this.note,
    this.by,
  });

  factory BillPayment.fromJson(Map<String, dynamic> j) => BillPayment(
    id: j['id'] as int?,
    amount: _num(j['amount']),
    methodLabel: j['methodLabel'] as String?,
    paidOn: j['paidOn'] == null ? null : DateTime.parse(j['paidOn'] as String),
    note: j['note'] as String?,
    by: j['by'] as String?,
  );

  /// Null for the delivery paid on acceptance: it is the parcel's own and is not deleted here.
  final int? id;
  final double? amount;
  final String? methodLabel;
  final DateTime? paidOn;
  final String? note;
  final String? by;
}

/// Loaders, works, storage and payments of a move; every change answers with the whole bill.
class MoveBillApi {
  MoveBillApi(this._dio);

  final Dio _dio;

  Future<MoveBill> bill(int id) =>
      _bill(() => _dio.get('/api/parcels/$id/bill'));

  Future<MoveBill> addWork(int id, Map<String, dynamic> body) =>
      _bill(() => _dio.post('/api/parcels/$id/works', data: body));

  Future<MoveBill> updateWork(int id, int workId, Map<String, dynamic> body) =>
      _bill(() => _dio.put('/api/parcels/$id/works/$workId', data: body));

  Future<MoveBill> deleteWork(int id, int workId) =>
      _bill(() => _dio.delete('/api/parcels/$id/works/$workId'));

  Future<MoveBill> setFact(
    int id,
    int workId,
    int loaderId, {
    required bool paid,
    double? actualHours,
  }) => _bill(
    () => _dio.put(
      '/api/parcels/$id/works/$workId/loaders/$loaderId',
      data: {'actualHours': actualHours, 'paid': paid},
    ),
  );

  Future<MoveBill> addPayment(int id, Map<String, dynamic> body) =>
      _bill(() => _dio.post('/api/parcels/$id/payments', data: body));

  Future<MoveBill> deletePayment(int id, int paymentId) =>
      _bill(() => _dio.delete('/api/parcels/$id/payments/$paymentId'));

  Future<MoveBill> addStorage(int id, Map<String, dynamic> body) =>
      _bill(() => _dio.post('/api/parcels/$id/storages', data: body));

  Future<MoveBill> deleteStorage(int id, int storageId) =>
      _bill(() => _dio.delete('/api/parcels/$id/storages/$storageId'));

  Future<List<Loader>> loaders() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/loaders',
        queryParameters: {'size': 500},
      );
      return [
        for (final l in (res.data!['content'] as List))
          Loader.fromJson((l as Map).cast<String, dynamic>()),
      ];
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<Loader> createLoader(Map<String, dynamic> body) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/loaders',
        data: body,
      );
      return Loader.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<MoveBill> _bill(Future<Response<dynamic>> Function() call) async {
    try {
      final res = await call();
      return MoveBill.fromJson((res.data as Map).cast<String, dynamic>());
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final moveBillApiProvider = Provider<MoveBillApi>(
  (ref) => MoveBillApi(ref.watch(dioProvider)),
);

final moveBillProvider = FutureProvider.autoDispose.family<MoveBill, int>(
  (ref, id) => ref.watch(moveBillApiProvider).bill(id),
);

final loadersProvider = FutureProvider.autoDispose<List<Loader>>(
  (ref) => ref.watch(moveBillApiProvider).loaders(),
);
