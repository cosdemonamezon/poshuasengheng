// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['name'] as String?,
      json['price'] as num?,
      json['rate'] as num?,
      json['status'] as bool?,
      json['sum'] as num?,
      json['qty'] as int?,
      json['id'] as int?,
      json['type'] as String?,
      json['code'] as String?,
      json['bag'] as num?,
      json['unitItemId'] as int?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'rate': instance.rate,
      'status': instance.status,
      'sum': instance.sum,
      'qty': instance.qty,
      'id': instance.id,
      'type': instance.type,
      'code': instance.code,
      'bag': instance.bag,
      'unitItemId': instance.unitItemId,
    };
