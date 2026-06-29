import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/models/expense_model.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/models/user_model.dart';
import 'package:vsplit/providers/expense_provider.dart';
import 'package:vsplit/providers/group_provider.dart';
import 'package:vsplit/screens/expence/add_expense_screen.dart';
import 'package:vsplit/widgets/app_text.dart';
import 'package:vsplit/widgets/expense_card.dart';
import 'package:vsplit/widgets/total_expense.dart';

class GroupDetailScreen extends StatefulWidget {
  final GroupModel group;
  const GroupDetailScreen({super.key, required this.group});
  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Stream<QuerySnapshot> _expenseStream;
  List<UserModel> _members = [];

  @override
  void initState() {
    super.initState();
    _expenseStream = context.read<ExpenseProvider>().getExpenses(
      widget.group.groupID,
    );
    loadMembers();
  }

  Future<void> loadMembers() async {
    List<UserModel> loaded = [];
    for (final uid in widget.group.members) {
      final user = await context.read<GroupProvider>().getUserById(uid);
      loaded.add(user);
    }
    setState(() => _members = loaded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
        actions: [
          PopupMenuButton<String>(
            color: const Color.fromARGB(255, 63, 61, 61),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(13),
            ),
            itemBuilder: (BuildContext context) {
              return [
                if (widget.group.adminUid ==
                    FirebaseAuth.instance.currentUser!.uid)
                  PopupMenuItem<String>(
                    value: "delete_group",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color.fromARGB(
                              255,
                              63,
                              61,
                              61,
                            ),
                            title: AppText(
                              text: "Are you sure to delete this group?",
                              textFontSize: 17,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: AppText(text: "Cancel"),
                              ),
                              ElevatedButton(
                                onPressed:
                                    context.watch<GroupProvider>().isDeleting
                                    ? null
                                    : () async {
                                        try {
                                          await context
                                              .read<GroupProvider>()
                                              .deleteGroup(
                                                widget.group.groupID,
                                              );
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          snackBarMessage(
                                            context,
                                            e.toString(),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: context.watch<GroupProvider>().isDeleting
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
                    child: AppText(
                      text: "Delete Group",
                      textColor: Colors.white,
                    ),
                  ),
                if (widget.group.adminUid !=
                    FirebaseAuth.instance.currentUser!.uid)
                  PopupMenuItem<String>(
                    value: "remove_group",
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: const Color.fromARGB(
                              255,
                              63,
                              61,
                              61,
                            ),
                            title: AppText(
                              text:
                                  "Are you sure you want to leave this group?",
                              textFontSize: 17,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: AppText(text: "Cancel"),
                              ),
                              ElevatedButton(
                                onPressed:
                                    context.watch<GroupProvider>().isRemoving
                                    ? null
                                    : () async {
                                        try {
                                          await context
                                              .read<GroupProvider>()
                                              .removeGroup(
                                                widget.group.groupID,
                                              );
                                          if (!mounted) return;
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } catch (e) {
                                          snackBarMessage(
                                            context,
                                            e.toString(),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: context.watch<GroupProvider>().isRemoving
                                    ? SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : AppText(text: "Remove"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: AppText(
                      text: "Leave Group",
                      textColor: Colors.white,
                    ),
                  ),
              ];
            },
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.group.description != null &&
                        widget.group.description != "")
                      AppText(
                        text: "Description: ${widget.group.description}",
                        textFontSize: 16,
                      ),
                    SizedBox(height: 15),
                    if (widget.group.currency != null &&
                        widget.group.currency != "")
                      AppText(text: "Currency: ${widget.group.currency}"),
                    AppText(
                      text: "Group Creator: ${widget.group.createdBy}",
                      textFontSize: 16,
                    ),
                    AppText(
                      text:
                          "Created on ${DateFormat('dd MMM yyyy , hh:mm a').format(widget.group.createdAt!)}",
                      textFontSize: 16,
                      textColor: Colors.grey,
                    ),
                    AppText(
                      text: "Join code: ${widget.group.joinCode}",
                      textColor: AppTheme.green,
                      textFontSize: 16,
                    ),
                    SizedBox(height: 18),
                    if (_members.isEmpty)
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      ),

                    AppText(text: "Members: "),
                    Wrap(
                      children: _members.map((user) {
                        return AppText(
                          text: user == _members.last
                              ? user.fullName
                              : "${(user.fullName)}, ",
                          textFontSize: 16,
                        );
                      }).toList(),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(
                        top: 18,
                        left: 5,
                        bottom: 5,
                        right: 5,
                      ),
                      child: TotalExpense(group: widget.group),
                    ),
                  ],
                ),
              ),
            ),

            StreamBuilder(
              stream: _expenseStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(child: AppText(text: "Something went wrong")),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(child: AppText(text: "No Expenses yet.")),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final expense = ExpenseModel.fromMap(
                      snapshot.data!.docs[index].data() as Map<String, dynamic>,
                    );
                    return ExpenseCard(
                      expense: expense,
                      group: widget.group,
                      key: ValueKey(expense.expenseId),
                    );
                  }, childCount: snapshot.data!.docs.length),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddExpenseScreen(group: widget.group),
            ),
          );
        },
        icon: Icon(Icons.add, color: Colors.white),
        label: AppText(
          text: "Add Expense",
          textFontSize: 16,
          textFontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
