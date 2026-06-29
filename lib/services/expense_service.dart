import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vsplit/models/expense_model.dart';

class ExpenseService {
  Future<void> addExpence(ExpenseModel expenseModel, String groupId) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('expenses')
          .doc(expenseModel.expenseId)
          .set(expenseModel.toMap());
    } catch (e) {
      throw "Unable to add expense. Try again.";
    }
  }

  Stream<QuerySnapshot> getExpenses(String groupId) {
    return FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('expenses')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> deleteExpense(String groupId, String expenseId) async {
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('expenses')
          .doc(expenseId)
          .delete();
    } catch (e) {
      throw "Unable to delete expense. Try again.";
    }
  }

  Future<Map<String, double>> getExpenseSummary(
    String groupId,
    String currentUserUid,
  ) async {
    try {
      double groupTotal = 0;
      double yourPortion = 0;
      double youGetBack = 0;

      final result = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('expenses')
          .get();
      for (final e in result.docs) {
        groupTotal += e['amount'];

        final expense = ExpenseModel.fromMap(e.data());
        if (expense.splitBetween.contains(currentUserUid) &&
            expense.paidBy != currentUserUid) {
          yourPortion += expense.perPersonAmount;
        }

        if (expense.paidBy == currentUserUid) {
          final membersPayMe = expense.splitBetween.contains(expense.paidBy)
              ? expense.splitBetween.length - 1
              : expense.splitBetween.length;
          final calculate = expense.perPersonAmount * membersPayMe;
          youGetBack += calculate;
        }
      }

      return {
        'groupTotal': groupTotal,
        'yourPortion': yourPortion,
        'youGetBack': youGetBack,
      };
    } catch (e) {
      throw "Unable to get Expense details.";
    }
  }
}
