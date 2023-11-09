import 'package:json_annotation/json_annotation.dart';
import 'package:poshuasengheng/models/user.dart';

part 'auth.g.dart';

@JsonSerializable()
class Auth {
  User? user;
  String token;

  Auth(
    this.user,
    this.token
  );

  factory Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

  Map<String, dynamic> toJson() => _$AuthToJson(this);

}
