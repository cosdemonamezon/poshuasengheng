// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemcategorys.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCategorys _$ItemCategorysFromJson(Map<String, dynamic> json) =>
    ItemCategorys(
      json['id'] as int?,
      json['clientId'] as String?,
      json['details'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$ItemCategorysToJson(ItemCategorys instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'clientId': instance.clientId,
    };
