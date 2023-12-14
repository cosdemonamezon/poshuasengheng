// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['id'] as int?,
      json['name'] as String?,
      // json['itemId'] as int?,
      json['bag'] as num?,
      json['qty'] as int?,
      json['unitItemId'] as int?,
      json['price'] as num?,
      json['discount'] as num?,
      json['sum'] as num?,
      json['type'] as String?,
      json['code'] as String?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      // 'itemId': instance.itemId,
      'qty': instance.qty,
      'unitItemId': instance.unitItemId,
      'bag': instance.bag,
      'price': instance.price,
      'discount': instance.discount,
      'sum': instance.sum,
      'type': instance.type,
      'code': instance.code,
    };
