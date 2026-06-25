import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/models/expense_model.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/providers/expense_provider.dart';
import 'package:vsplit/providers/group_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class ExpenseCard extends StatefulWidget {
  final ExpenseModel expense;
  final GroupModel group;
  const ExpenseCard({super.key, required this.expense, required this.group});

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  Future<List<String>> _getSplitNames() async {
    List<String> names = [];
    for (final uid in widget.expense.splitBetween) {
      final user = await context.read<GroupProvider>().getUserById(uid);
      names.add(user.fullName);
    }
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onLongPress: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: const Color.fromARGB(255, 63, 61, 61),
                title: AppText(
                  text: "Are you sure you want to delete this Expense?",
                  textFontSize: 17,
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: AppText(text: "Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await context.read<ExpenseProvider>().deleteExpense(
                          widget.group.groupID,
                          widget.expense.expenseId,
                        );
                        if (!mounted) return;
                        Navigator.pop(context);
                      } catch (e) {
                        if (!mounted) return;
                        snackBarMessage(context, e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: context.watch<ExpenseProvider>().deletingExpense
                        ? SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : AppText(text: "Delete"),
                  ),
                ],
              );
            },
          );
        },
        child: Card(
          color: Color(0xff2c2c2c),
          child: Padding(
            padding: const EdgeInsets.all(11.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(text: widget.expense.name, textFontSize: 16),
                    AppText(
                      text: widget.expense.amount.toString(),
                      textFontSize: 17,
                      textFontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppText(text: "Paid by: "),
                    FutureBuilder(
                      future: context.read<GroupProvider>().getUserById(
                        widget.expense.paidBy,
                      ),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return AppText(text: "...");
                        return AppText(
                          text: snapshot.data!.fullName,
                          textFontWeight: FontWeight.w500,
                        );
                      },
                    ),
                  ],
                ),
                AppText(
                  text:
                      "Per person: ${widget.expense.perPersonAmount.toStringAsFixed(2)}",
                  textFontSize: 16,
                  textFontWeight: FontWeight.w600,
                ),
                FutureBuilder<List<String>>(
                  future: _getSplitNames(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return AppText(text: "Loading...");
                    return AppText(
                      text: "Split: ${snapshot.data!.join(', ')}",
                      textFontSize: 14,
                      textColor: Colors.grey,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
