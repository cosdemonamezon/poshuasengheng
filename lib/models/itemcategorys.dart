import 'package:json_annotation/json_annotation.dart';

part 'itemcategorys.g.dart';

@JsonSerializable()
class ItemCategorys {
  int? id;
  String? name;
  String? details;
  String? clientId;

  ItemCategorys(this.id, this.clientId, this.details, this.name,);

  factory ItemCategorys.fromJson(Map<String, dynamic> json) => _$ItemCategorysFromJson(json);

  Map<String, dynamic> toJson() => _$ItemCategorysToJson(this);
}
