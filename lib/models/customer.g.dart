// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      json['licensePage'] as String?,
      json['name'] as String?,
      json['tel'] as String?,
      json['payMentType'] as String?,
      json['id'] as int?,
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'licensePage': instance.licensePage,
      'name': instance.name,
      'tel': instance.tel,
      'payMentType': instance.payMentType,
      'id': instance.id,
    };
