import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ExpenseModel {
  int id;
  String title;
  double amount;
  bool isAmountType;
  ExpenseModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.isAmountType,
  });

  ExpenseModel copyWith({
    int? id,
    String? title,
    double? amount,
    bool? isAmountType,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      isAmountType: isAmountType ?? this.isAmountType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'amount': amount,
      'isAmountType': isAmountType,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] as int,
      title: map['title'] as String,
      amount: map['amount'] as double,
      isAmountType: map['isAmountType'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) => ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);
}