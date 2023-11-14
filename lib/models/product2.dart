import 'package:json_annotation/json_annotation.dart';
import 'package:poshuasengheng/models/itemunitprices.dart';

part 'product2.g.dart';

@JsonSerializable()
class Product2 {
  final int id;
  String? code;
  int? stock;
  int? atLeastStock;
  String? unit;
  int? unitId;
  String? name;
  int? cost;
  int? profit;
  int? price;
  String? details;
  String? image;
  int? memberId;
  String? clientId;
  bool? status;
  int? qty;
  int? qtyPack;
  bool? select;
  String? createBy;
  String? updateBy;
  List<ItemUnitPrices>? itemUnitPrices;
  // ItemCategorys? itemCategory;
  int? current_price;
  int? current_price_per_unit;
  int? current_total_price;

  Product2(
    this.id,
    this.atLeastStock,
    this.clientId,
    this.code,
    this.cost,
    this.createBy,
    this.details,
    this.image,
    this.memberId,
    this.name,
    this.price,
    this.profit,
    this.status,
    this.stock,
    this.unit,
    this.itemUnitPrices,
    this.unitId,
    this.current_price,
    this.current_price_per_unit,
    this.current_total_price,
    this.updateBy, {
    this.select = false,
    this.qty = 1,
    this.qtyPack = 1,
  });

  factory Product2.fromJson(Map<String, dynamic> json) => _$Product2FromJson(json);

  Map<String, dynamic> toJson() => _$Product2ToJson(this);
}
