import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  final String expenseId;
  final String name;
  final double amount;
  final String paidBy;
  final List<String> splitBetween;
  final DateTime? createdAt;
  final double perPersonAmount;

  ExpenseModel({
    required this.expenseId,
    required this.name,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
    this.createdAt,
    required this.perPersonAmount
  });

  factory ExpenseModel.fromMap(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expenseId'],
      name: json['name'],
      amount: json['amount'] as double,
      paidBy: json['paidBy'],
      splitBetween: List<String>.from(json['splitBetween']),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
      perPersonAmount: json['perPersonAmount'] as double
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "expenseId": expenseId,
      "name": name,
      "amount": amount,
      "paidBy": paidBy,
      "splitBetween": splitBetween,
      "createdAt": FieldValue.serverTimestamp(),
      "perPersonAmount" : perPersonAmount
    };
  }
}
