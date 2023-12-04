// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product2 _$Product2FromJson(Map<String, dynamic> json) => Product2(
      json['id'] as int,
      json['atLeastStock'] as int?,
      json['clientId'] as String?,
      json['code'] as String?,
      json['cost'] as int?,
      json['createBy'] as String?,
      json['details'] as String?,
      json['image'] as String?,
      json['memberId'] as int?,
      json['name'] as String?,
      json['price'] as int?,
      json['profit'] as int?,
      json['status'] as bool?,
      json['stock'] as int?,
      json['unit'] as String?,
      (json['itemUnitPrices'] as List<dynamic>?)
          ?.map((e) => ItemUnitPrices.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['unitId'] as int?,
      json['current_price'] as num?,
      json['current_price_per_unit'] as num?,
      json['current_total_price'] as num?,
      json['updateBy'] as String?,
      select: json['select'] as bool? ?? false,
      qty: json['qty'] as int? ?? 1,
      qtyPack: json['qtyPack'] as num? ?? 1,
    );

Map<String, dynamic> _$Product2ToJson(Product2 instance) => <String, dynamic>{
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
      'status': instance.status,
      'qty': instance.qty,
      'qtyPack': instance.qtyPack,
      'select': instance.select,
      'createBy': instance.createBy,
      'updateBy': instance.updateBy,
      'itemUnitPrices': instance.itemUnitPrices,
      'current_price': instance.current_price,
      'current_price_per_unit': instance.current_price_per_unit,
      'current_total_price': instance.current_total_price,
    };
