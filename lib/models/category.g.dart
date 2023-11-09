// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      json['id'] as int?,
      json['name'] as String?,
      json['details'] as String?,
      json['status'] as bool?,
      json['clientId'] as String?,
      json['createBy'] as String?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'status': instance.status,
      'clientId': instance.clientId,
      'createBy': instance.createBy,
    };
