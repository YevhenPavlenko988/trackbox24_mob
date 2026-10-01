import 'package:freezed_annotation/freezed_annotation.dart';

part 'warehouse_model.freezed.dart';
part 'warehouse_model.g.dart';

@freezed
abstract class Warehouse with _$Warehouse {
  const factory Warehouse({
    required int id,
    required String name,
    String? address,
    String? notes,
    @Default(true) bool active,
  }) = _Warehouse;

  factory Warehouse.fromJson(Map<String, dynamic> json) =>
      _$WarehouseFromJson(json);
}
