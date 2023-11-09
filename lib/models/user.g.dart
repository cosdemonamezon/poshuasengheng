// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      json['id'] as int,
      json['username'] as String?,
      json['name'] as String?,
      json['tel'] as String?,
      json['image'] as String?,
      json['email'] as String?,
      json['status'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'name': instance.name,
      'tel': instance.tel,
      'image': instance.image,
      'email': instance.email,
      'status': instance.status,
    };
