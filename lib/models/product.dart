import 'package:json_annotation/json_annotation.dart';
import 'package:poshuasengheng/models/itemcate.dart';
import 'package:poshuasengheng/models/itemcategorys.dart';
import 'package:poshuasengheng/models/itemunitprices.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  String? code;
  int? stock;
  int? atLeastStock;
  String? unit;
  int? unitId;
  String? name;
  num? cost;
  num? profit;
  num? price;
  String? details;
  String? image;
  int? memberId;
  String? clientId;
  bool? status;
  int? qty;
  num? qtyPack;
  bool? select;
  String? createBy;
  String? updateBy;
  List<ItemUnitPrices>? itemUnitPrices;
  // ItemCategorys? itemCategory;

  Product(
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
    this.updateBy, {
    this.select = false,
    this.qty = 1,
    this.qtyPack = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
