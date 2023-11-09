import 'package:json_annotation/json_annotation.dart';

part 'orderdraft.g.dart';

@JsonSerializable()
class OrderDraft {
  final int id;
  DateTime? date;
  String? draft_order_no;
  String? clientId;
  String? status;
  String? createBy;

  OrderDraft(this.id, this.clientId, this.createBy, this.date, this.draft_order_no, this.status);

  factory OrderDraft.fromJson(Map<String, dynamic> json) => _$OrderDraftFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDraftToJson(this);
}
