import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  String? username;
  String? name;
  String? tel;
  String? image;
  String? email;
  String? status;

  User(
    this.id,
    this.username,
    this.name,
    this.tel,
    this.image,
    this.email,
    this.status
  );

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
