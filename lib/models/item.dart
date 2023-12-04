import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int? itemId;
  int? qty;
  int? unitItemId;
  num? bag;
  num? price;
  num? discount;
  num? total;

  Item(
    this.itemId,
    this.bag,
    this.qty,
    this.unitItemId,
    this.price,
    this.discount,
    this.total,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
