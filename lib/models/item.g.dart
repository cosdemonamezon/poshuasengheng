// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
      json['itemId'] as int?,
      json['bag'] as int?,
      json['qty'] as int?,
      json['unitItemId'] as int?,
    );

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'qty': instance.qty,
      'unitItemId': instance.unitItemId,
      'bag': instance.bag,
    };
