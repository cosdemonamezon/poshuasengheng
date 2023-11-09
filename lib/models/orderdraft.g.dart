// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderdraft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDraft _$OrderDraftFromJson(Map<String, dynamic> json) => OrderDraft(
      json['id'] as int,
      json['clientId'] as String?,
      json['createBy'] as String?,
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      json['draft_order_no'] as String?,
      json['status'] as String?,
    );

Map<String, dynamic> _$OrderDraftToJson(OrderDraft instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'draft_order_no': instance.draft_order_no,
      'clientId': instance.clientId,
      'status': instance.status,
      'createBy': instance.createBy,
    };
