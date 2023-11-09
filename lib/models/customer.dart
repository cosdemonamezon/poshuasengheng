import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  String? licensePage;
  String? name;
  String? tel;
  int? id;

  Customer(
    this.licensePage,
    this.name,
    this.tel,
    this.id
  );

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
