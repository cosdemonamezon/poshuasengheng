// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemcate.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Itemcate _$ItemcateFromJson(Map<String, dynamic> json) => Itemcate(
      json['id'] as int?,
      json['clientId'] as String?,
      json['details'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$ItemcateToJson(Itemcate instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'clientId': instance.clientId,
    };
