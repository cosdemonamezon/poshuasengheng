import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  String? name;
  num? price;
  num? rate;
  bool? status;
  num? sum;
  int? qty;
  int? id;
  String? type;
  String? code;
  num? bag;
  int? unitItemId;

  Item(
    this.name,
    this.price,
    this.rate,
    this.status,
    this.sum,
    this.qty,
    this.id,
    this.type,
    this.code,
    this.bag,
    this.unitItemId,
  );

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
