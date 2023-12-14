// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemAll.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemAll _$ItemAllFromJson(Map<String, dynamic> json) => ItemAll(
      json['id'] as int?,
      json['name'] as String?,
      json['value'] as int?,
      json['price'] as int?,
      json['status'] as bool?,
      json['item'] == null
          ? null
          : ItemID.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemAllToJson(ItemAll instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'price': instance.price,
      'status': instance.status,
      'item': instance.item,
    };
