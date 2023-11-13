import 'package:json_annotation/json_annotation.dart';

part 'itemunitprices.g.dart';

@JsonSerializable()
class ItemUnitPrices {
  int? id;
  String? name;
  int? value;
  int? price;

  ItemUnitPrices(this.id, this.price, this.name, this.value);

  factory ItemUnitPrices.fromJson(Map<String, dynamic> json) => _$ItemUnitPricesFromJson(json);

  Map<String, dynamic> toJson() => _$ItemUnitPricesToJson(this);
}
