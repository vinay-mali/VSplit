import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenceModel {
  final String name;
  final double amount;
  final String paidBy;
  final List<String> splitBetween;
  final DateTime? createdAt;

  ExpenceModel({
    required this.name,
    required this.amount,
    required this.paidBy,
    required this.splitBetween,
    required this.createdAt,
  });

  factory ExpenceModel.fromMap(Map<String, dynamic> json) {
    return ExpenceModel(
      name: json['name'],
      amount: json['amount'],
      paidBy: json['paidBy'],
      splitBetween: json['splitBetween'] as List<String>,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "amount" : amount,
      "paidBy" : paidBy,
      "splitBetween" : splitBetween,
      "createdAt" : FieldValue.serverTimestamp()
      
    };
  }
}
