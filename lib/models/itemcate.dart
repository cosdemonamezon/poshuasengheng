import 'package:json_annotation/json_annotation.dart';

part 'itemcate.g.dart';

@JsonSerializable()
class Itemcate {
  int? id;
  String? name;
  String? details;
  String? clientId;

  Itemcate(this.id, this.clientId, this.details, this.name,);

  factory Itemcate.fromJson(Map<String, dynamic> json) => _$ItemcateFromJson(json);

  Map<String, dynamic> toJson() => _$ItemcateToJson(this);
}
