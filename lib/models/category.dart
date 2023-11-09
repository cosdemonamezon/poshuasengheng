
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  int? id;
  String? name;
  String? details;
  bool? status;
  String? clientId;
  String? createBy;
  

  Category(
    this.id, this.name, this.details, this.status, this.clientId, this.createBy
  );

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
