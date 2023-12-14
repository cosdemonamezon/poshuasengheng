// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemID.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemID _$ItemIDFromJson(Map<String, dynamic> json) => ItemID(
      json['id'] as int?,
      json['code'] as String?,
      json['stock'] as int?,
      json['atLeastStock'] as int?,
      json['unit'] as String?,
      json['unitId'] as int?,
      json['name'] as String?,
      json['cost'] as num?,
      json['profit'] as num?,
      json['price'] as num?,
      json['details'] as String?,
      json['image'] as String?,
      json['memberId'] as int?,
      json['clientId'] as String?,
      json['min'] as int?,
      json['max'] as int?,
      json['status'] as bool?,
    );

Map<String, dynamic> _$ItemIDToJson(ItemID instance) => <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'stock': instance.stock,
      'atLeastStock': instance.atLeastStock,
      'unit': instance.unit,
      'unitId': instance.unitId,
      'name': instance.name,
      'cost': instance.cost,
      'profit': instance.profit,
      'price': instance.price,
      'details': instance.details,
      'image': instance.image,
      'memberId': instance.memberId,
      'clientId': instance.clientId,
      'min': instance.min,
      'max': instance.max,
      'status': instance.status,
    };
