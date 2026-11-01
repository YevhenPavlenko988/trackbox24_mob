import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trackbox24_mob/core/api/page.dart';
import 'package:trackbox24_mob/core/api/problem.dart';
import 'package:trackbox24_mob/core/providers.dart';
import 'package:trackbox24_mob/features/warehouses/data/warehouse_model.dart';

class WarehouseApi {
  WarehouseApi(this._dio);

  final Dio _dio;

  Future<List<Warehouse>> listActive() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/api/warehouses',
        queryParameters: {'active': true, 'size': 100},
      );
      return Page.fromJson(res.data!, Warehouse.fromJson).content;
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// A new warehouse, added on the way by whoever leaves the cargo there.
  Future<Warehouse> create({required String name, String? address}) async {
    try {
      final res = await _dio.post<Map<String, dynamic>>(
        '/api/warehouses',
        data: {
          'name': name,
          if (address != null && address.isNotEmpty) 'address': address,
        },
      );
      return Warehouse.fromJson(res.data!);
    } catch (e) {
      throw toApiException(e);
    }
  }

  /// `POST /api/warehouses/{id}/parcels` — moves every seat of each parcel, all-or-nothing.
  Future<void> moveParcels(
    int warehouseId,
    List<int> parcelIds, {
    String? comment,
  }) async {
    try {
      await _dio.post<void>(
        '/api/warehouses/$warehouseId/parcels',
        data: {'parcelIds': parcelIds, if (comment != null) 'comment': comment},
      );
    } catch (e) {
      throw toApiException(e);
    }
  }
}

final warehouseApiProvider = Provider<WarehouseApi>(
  (ref) => WarehouseApi(ref.watch(dioProvider)),
);

final activeWarehousesProvider = FutureProvider<List<Warehouse>>(
  (ref) => ref.watch(warehouseApiProvider).listActive(),
);
