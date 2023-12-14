import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? id;
  String? name;
  // int? itemId;
  int? qty;
  int? unitItemId;
  num? bag;
  num? price;
  num? discount;
  num? sum;
  String? type;
  String? code;

  Item(
    this.id,
    this.name,
    // this.itemId,
    this.bag,
    this.qty,
    this.unitItemId,
    this.price,
    this.discount,
    this.sum,
    this.type,
    this.code,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
