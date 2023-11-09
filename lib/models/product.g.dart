// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      json['id'] as int,
      json['atLeastStock'] as int?,
      json['clientId'] as String?,
      json['code'] as String?,
      json['cost'] as int?,
      json['createBy'] as String?,
      json['details'] as String?,
      json['image'] as String?,
      json['itemCategory'] == null
          ? null
          : ItemCategory.fromJson(json['itemCategory'] as Map<String, dynamic>),
      json['memberId'] as int?,
      json['name'] as String?,
      json['price'] as int?,
      json['profit'] as int?,
      json['status'] as bool?,
      json['stock'] as int?,
      json['unit'] as String?,
      json['unitId'] as int?,
      json['updateBy'] as String?,
      select: json['select'] as bool? ?? false,
      qty: json['qty'] as int? ?? 1,
      qtyPack: json['qtyPack'] as int? ?? 1,
    );

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
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
      'itemCategory': instance.itemCategory,
    };
