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
}
