// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupproduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupProduct _$GroupProductFromJson(Map<String, dynamic> json) => GroupProduct(
      json['name'] as String?,
      (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupProductToJson(GroupProduct instance) =>
    <String, dynamic>{
      'name': instance.name,
      'products': instance.products,
    };
