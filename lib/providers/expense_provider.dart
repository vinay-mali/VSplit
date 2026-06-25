import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/models/expense_model.dart';
import 'package:vsplit/services/expense_service.dart';

class ExpenseProvider extends ChangeNotifier {
  final ExpenseService _expenseService = ExpenseService();
  bool _addingExpenseLoading = false;
  bool get addingExpenseLoading => _addingExpenseLoading;

  Future<void> addExpence(
    String groupId,
    String name,
    double amount,
    String paidBy,
    List<String> splitBetween,
    double perPersonAmount,
  ) async {
    try {
      _addingExpenseLoading = true;
      notifyListeners();
      final expenseId = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('expenses')
          .doc()
          .id;
      final ExpenseModel expenseModel = ExpenseModel(
        expenseId: expenseId,
        name: name,
        amount: amount,
        paidBy: paidBy,
        splitBetween: splitBetween,
        perPersonAmount: perPersonAmount,
      );
      await _expenseService.addExpence(expenseModel, groupId);
      
    } catch (e) {
      rethrow;
    } finally {
      _addingExpenseLoading = false;
      notifyListeners();
    }
  }
  bool _deletingExpense = false;
bool get deletingExpense => _deletingExpense;

Stream<QuerySnapshot> getExpenses(String groupId) {
  return _expenseService.getExpenses(groupId);
}

Future<void> deleteExpense(String groupId, String expenseId) async {
  try {
    _deletingExpense = true;
    notifyListeners();
    await _expenseService.deleteExpense(groupId, expenseId);
  } catch (e) {
    rethrow;
  } finally {
    _deletingExpense = false;
    notifyListeners();
  }
}
}
