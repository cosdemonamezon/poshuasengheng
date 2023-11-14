import 'package:json_annotation/json_annotation.dart';

part 'priceUint.g.dart';

@JsonSerializable()
class PriceUint {
  int? price;
  String? price_per_unit;

  PriceUint(
    this.price,
    this.price_per_unit,
  );

  factory PriceUint.fromJson(Map<String, dynamic> json) => _$PriceUintFromJson(json);

  Map<String, dynamic> toJson() => _$PriceUintToJson(this);
}
