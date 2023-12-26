import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final int id;
  String? date;
  String? time;
  String? refNo;

  Transaction(
    this.id,
    this.date,
    this.time,
    this.refNo,
  );

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
