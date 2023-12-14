import 'package:json_annotation/json_annotation.dart';
import 'package:poshuasengheng/models/itemID.dart';

part 'itemAll.g.dart';

@JsonSerializable()
class ItemAll {
  int? id;
  String? name;
  int? value;
  int? price;
  bool? status;
  ItemID? item;

  ItemAll(
    this.id,
    this.name,
    this.value,
    this.price,
    this.status,
    this.item,
  );

  factory ItemAll.fromJson(Map<String, dynamic> json) => _$ItemAllFromJson(json);

  Map<String, dynamic> toJson() => _$ItemAllToJson(this);
}
