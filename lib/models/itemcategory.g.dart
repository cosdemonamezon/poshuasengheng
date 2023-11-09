// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemcategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemCategory _$ItemCategoryFromJson(Map<String, dynamic> json) => ItemCategory(
      json['id'] as int,
      json['clientId'] as String?,
      json['createBy'] as String?,
      json['details'] as String?,
      json['name'] as String?,
      json['status'] as bool?,
      json['updateBy'] as String?,
    );

Map<String, dynamic> _$ItemCategoryToJson(ItemCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'status': instance.status,
      'clientId': instance.clientId,
      'createBy': instance.createBy,
      'updateBy': instance.updateBy,
    };
