import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';

double _num(Object? v) => v == null ? 0 : (v as num).toDouble();

/// What the payer may spend on a parcel now («Реферальна програма»).
class RedeemInfo {
  const RedeemInfo({
    required this.balance,
    required this.maxPoints,
    required this.pointValue,
    this.currency,
    this.reason,
  });

  factory RedeemInfo.fromJson(Map<String, dynamic> j) => RedeemInfo(
    balance: (j['balance'] as num?)?.toInt() ?? 0,
    maxPoints: (j['maxPoints'] as num?)?.toInt() ?? 0,
    pointValue: _num(j['pointValue']),
    currency: j['currency'] as String?,
    reason: j['reason'] as String?,
  );

  final int balance;
  final int maxPoints;

  /// One point in the parcel's price currency.
  final double pointValue;
  final String? currency;

  /// Why nothing can be spent, when [maxPoints] is 0.
  final String? reason;
}

class ReferralApi {
  ReferralApi(this._dio);

  final Dio _dio;

  /// At hand-over: the points of the parcel's client (our client) for this parcel.
  Future<RedeemInfo> forParcel(int parcelId) =>
      _info('/api/referral/parcels/$parcelId/redeem', const {});

  /// At acceptance the parcel does not exist yet: the client's points for this price.
  Future<RedeemInfo> forNew(int clientId, double price, String currency) =>
      _info('/api/referral/clients/$clientId/redeem', {
        'price': price,
        'currency': currency,
      });

  Future<RedeemInfo> _info(String path, Map<String, dynamic> query) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: query,
      );
      return RedeemInfo.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final referralApiProvider = Provider<ReferralApi>(
  (ref) => ReferralApi(ref.watch(dioProvider)),
);
