// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itemunitprices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemUnitPrices _$ItemUnitPricesFromJson(Map<String, dynamic> json) =>
    ItemUnitPrices(
      json['id'] as int?,
      json['price'] as int?,
      json['name'] as String?,
      json['value'] as int?,
    );

Map<String, dynamic> _$ItemUnitPricesToJson(ItemUnitPrices instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'value': instance.value,
      'price': instance.price,
    };
