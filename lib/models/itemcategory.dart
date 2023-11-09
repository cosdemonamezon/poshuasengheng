import 'package:json_annotation/json_annotation.dart';

part 'itemcategory.g.dart';

@JsonSerializable()
class ItemCategory {
  final int id;
  String? name;
  String? details;
  bool? status;
  String? clientId;
  String? createBy;
  String? updateBy;

  ItemCategory(this.id, this.clientId, this.createBy, this.details, this.name, this.status, this.updateBy);

  factory ItemCategory.fromJson(Map<String, dynamic> json) => _$ItemCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ItemCategoryToJson(this);
}
