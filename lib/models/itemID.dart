import 'package:json_annotation/json_annotation.dart';

part 'itemID.g.dart';

@JsonSerializable()
class ItemID {
  int? id;
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
  int? min;
  int? max;
  bool? status;

  ItemID(
    this.id,
    this.code,
    this.stock,
    this.atLeastStock,
    this.unit,
    this.unitId,
    this.name,
    this.cost,
    this.profit,
    this.price,
    this.details,
    this.image,
    this.memberId,
    this.clientId,
    this.min,
    this.max,
    this.status,
  );

  factory ItemID.fromJson(Map<String, dynamic> json) => _$ItemIDFromJson(json);

  Map<String, dynamic> toJson() => _$ItemIDToJson(this);
}
