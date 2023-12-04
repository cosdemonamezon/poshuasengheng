// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['itemId'] as int?,
      json['bag'] as num?,
      json['qty'] as int?,
      json['unitItemId'] as int?,
      json['price'] as num?,
      json['discount'] as num?,
      json['bag'] as num?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'qty': instance.qty,
      'unitItemId': instance.unitItemId,
      'bag': instance.bag,
      'price': instance.price,
      'discount': instance.discount,
      'total': instance.total,
    };
