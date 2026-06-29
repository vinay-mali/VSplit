import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/providers/auth_user_provider.dart';
import 'package:vsplit/providers/expense_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class TotalExpense extends StatefulWidget {
  final GroupModel group;
  const TotalExpense({super.key, required this.group});

  @override
  State<TotalExpense> createState() => _TotalExpenseState();
}

class _TotalExpenseState extends State<TotalExpense> {
  late Future<Map<String, double>> _summaryFuture;
  @override
  void initState() {
    super.initState();
    final currentUser = context.read<AuthUserProvider>().getUserModel;
    _summaryFuture = context.read<ExpenseProvider>().getExpenseSummary(
      widget.group.groupID,
      currentUser.uid,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff003d4d), Color.fromARGB(255, 2, 116, 87)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            FutureBuilder(
              future: _summaryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return AppText(text: "...");
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        AppText(
                          text:
                              "${widget.group.currency} ${convertAmount(snapshot.data!['groupTotal'] ?? 0)}",
                          textFontSize: 18,
                          textFontWeight: FontWeight.w600,
                        ),

                        AppText(text: "Group Total", textFontSize: 12),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        AppText(
                          text:
                              "${widget.group.currency} ${convertAmount(snapshot.data!['yourPortion'] ?? 0)}",
                          textFontWeight: FontWeight.w600,
                          textFontSize: 18,
                        ),

                        AppText(text: "Your Portion", textFontSize: 12),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        AppText(
                          text:
                              "${widget.group.currency} ${convertAmount(snapshot.data!['youGetBack'] ?? 0)}",
                          textFontSize: 18,
                          textFontWeight: FontWeight.w600,
                        ),
                        AppText(text: "You get back", textFontSize: 12),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
