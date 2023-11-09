import 'package:json_annotation/json_annotation.dart';
import 'package:poshuasengheng/models/product.dart';

part 'groupproduct.g.dart';

@JsonSerializable()
class GroupProduct {
  String? name;
  List<Product> products;

  GroupProduct(this.name, this.products);

  factory GroupProduct.fromJson(Map<String, dynamic> json) => _$GroupProductFromJson(json);

  Map<String, dynamic> toJson() => _$GroupProductToJson(this);
}
