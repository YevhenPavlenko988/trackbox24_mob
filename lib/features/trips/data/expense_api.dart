import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

/// What an expense was for, in the order it is offered.
const expenseKinds = ['FUEL', 'TOLL', 'PARKING', 'REPAIR', 'FINE', 'OTHER'];

/// Whose money paid: the collected cash (less in hand), the driver's own, the company's.
const expensePaidFrom = ['COLLECTED_CASH', 'OWN', 'COMPANY'];

/// One expense of a trip («Звіти»): what, how much, from whose money, the receipt photo.
class TripExpense {
  const TripExpense({
    required this.id,
    required this.kind,
    required this.amount,
    required this.currency,
    required this.paidFrom,
    required this.editable,
    this.kindLabel,
    this.paidFromLabel,
    this.spentByName,
    this.spentAt,
    this.note,
    this.receiptUrl,
    this.receiptThumbUrl,
  });

  factory TripExpense.fromJson(Map<String, dynamic> j) => TripExpense(
    id: (j['id'] as num).toInt(),
    kind: j['kind'] as String,
    kindLabel: j['kindLabel'] as String?,
    amount: (j['amount'] as num).toDouble(),
    currency: j['currency'] as String,
    paidFrom: j['paidFrom'] as String,
    paidFromLabel: j['paidFromLabel'] as String?,
    spentByName: j['spentByName'] as String?,
    spentAt: j['spentAt'] == null
        ? null
        : DateTime.parse(j['spentAt'] as String),
    note: j['note'] as String?,
    receiptUrl: j['receiptUrl'] as String?,
    receiptThumbUrl: j['receiptThumbUrl'] as String?,
    editable: j['editable'] as bool? ?? false,
  );

  final int id;
  final String kind;
  final String? kindLabel;
  final double amount;
  final String currency;
  final String paidFrom;
  final String? paidFromLabel;
  final String? spentByName;
  final DateTime? spentAt;
  final String? note;
  final String? receiptUrl;
  final String? receiptThumbUrl;

  /// The signed-in person may change it: they entered it, or they are a manager.
  final bool editable;
}

class ExpenseApi {
  ExpenseApi(this._dio);

  final Dio _dio;

  Future<List<TripExpense>> list(int tripId) async {
    try {
      final res = await _dio.get<List<dynamic>>('/api/trips/$tripId/expenses');
      return [
        for (final e in res.data ?? const [])
          TripExpense.fromJson((e as Map).cast<String, dynamic>()),
      ];
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// Adds ([id] null) or changes an expense; who paid is the signed-in driver.
  Future<TripExpense> save(
    int tripId, {
    required String kind,
    required double amount,
    required String currency,
    required String paidFrom,
    int? id,
    String? note,
  }) async {
    final body = {
      'kind': kind,
      'amount': amount,
      'currency': currency,
      'paidFrom': paidFrom,
      'note': ?note,
    };
    try {
      final res = id == null
          ? await _dio.post<Map<String, dynamic>>(
              '/api/trips/$tripId/expenses',
              data: body,
            )
          : await _dio.put<Map<String, dynamic>>(
              '/api/trips/$tripId/expenses/$id',
              data: body,
            );
      return TripExpense.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  Future<void> delete(int tripId, int id) async {
    try {
      await _dio.delete<void>('/api/trips/$tripId/expenses/$id');
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// The receipt photo as it is (the server converts); a slow link gets long timeouts, like parcel photos.
  Future<TripExpense> receipt(int tripId, int id, XFile file) async {
    try {
      final form = FormData()
        ..files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(file.path, filename: file.name),
          ),
        );
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/trips/$tripId/expenses/$id/receipt',
        data: form,
        options: Options(
          sendTimeout: const Duration(minutes: 3),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );
      return TripExpense.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final expenseApiProvider = Provider<ExpenseApi>(
  (ref) => ExpenseApi(ref.watch(dioProvider)),
);

final tripExpensesProvider = FutureProvider.autoDispose
    .family<List<TripExpense>, int>(
      (ref, tripId) => ref.watch(expenseApiProvider).list(tripId),
    );
