import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/models/group_model.dart';
import 'package:vsplit/models/user_model.dart';
import 'package:vsplit/providers/expense_provider.dart';
import 'package:vsplit/providers/group_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class AddExpenseScreen extends StatefulWidget {
  final GroupModel group;
  const AddExpenseScreen({super.key, required this.group});
  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  TextEditingController titleCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  List<UserModel> members = [];
  List<String> splitBetween = [];
  String? selectedPaidBy;
  bool loadingMembers = true;

  @override
  void initState() {
    super.initState();
    loadMembers();
  }

  Future<void> loadMembers() async {
    List<UserModel> loaded = [];
    for (String uid in widget.group.members) {
      final member = await context.read<GroupProvider>().getUserById(uid);
      loaded.add(member);
    }
    setState(() {
      members = loaded;
      selectedPaidBy = FirebaseAuth.instance.currentUser!.uid;
      splitBetween = widget.group.members.toList();
      loadingMembers = false;
    });
  }

  Future<void> addExpence() async {
    if (titleCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please fill the required fields.");
      return;
    }
    if (splitBetween.isEmpty) {
      snackBarMessage(context, "Select at least one person to split.");
      return;
    }
    try {
      final perPersonAmount =
          (double.tryParse(amountCtrl.text.trim()) ?? 0) / splitBetween.length;
      await context.read<ExpenseProvider>().addExpence(
        widget.group.groupID,
        titleCtrl.text.trim(),
        double.tryParse(amountCtrl.text.trim()) ?? 0,
        selectedPaidBy.toString(),
        splitBetween,
        perPersonAmount,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      snackBarMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                child: TextField(
                  controller: titleCtrl,
                  style: GoogleFonts.poppins(color: Colors.white),
                  decoration: InputDecoration(labelText: "Expense Title"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: TextField(
                  controller: amountCtrl,
                  style: GoogleFonts.poppins(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: "${widget.group.currency} ",
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 15),
                    labelText: "Amount",
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: AppText(
                      text: "Paid by:  ",
                      textFontSize: 17,
                      textColor: AppTheme.reddish,
                    ),
                  ),
                  loadingMembers
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : DropdownButton(
                          iconEnabledColor: Colors.white,
                          value: selectedPaidBy,
                          dropdownColor: Color(0xff2c2c2c),
                          items: members.map((member) {
                            return DropdownMenuItem(
                              value: member.uid,
                              child: AppText(
                                text: member.fullName,
                                textColor: AppTheme.skybluish,
                              ),
                            );
                          }).toList(),

                          onChanged: (value) {
                            setState(() {
                              selectedPaidBy = value;
                            });
                          },
                        ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  left: 13,
                  right: 13,
                  bottom: 6,
                ),
                child: AppText(
                  text: "Split between: ",
                  textFontSize: 17,
                  textColor: AppTheme.reddish,
                ),
              ),
              if (loadingMembers)
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                ...members.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 4,
                    ),
                    child: CheckboxListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Color(0xff2c2c2c), width: 2),
                      ),

                      value: splitBetween.contains(user.uid),
                      title: AppText(text: user.fullName),
                      onChanged: (checked) {
                        setState(() {
                          if (checked!) {
                            splitBetween.add(user.uid);
                          } else {
                            splitBetween.remove(user.uid);
                          }
                        });
                      },
                    ),
                  );
                }),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 20,
                ),
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 160,
                        height: 55,

                        decoration: BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.rectangle,

                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 1,
                              blurRadius: 17,
                              color: Colors.pink,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 60,
                        child: ElevatedButton(
                          onPressed:
                              context
                                  .watch<ExpenseProvider>()
                                  .addingExpenseLoading
                              ? null
                              : addExpence,
                          child:
                              context
                                  .watch<ExpenseProvider>()
                                  .addingExpenseLoading
                              ? (SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ))
                              : AppText(
                                  text: "Add Expense",
                                  textFontSize: 18,
                                  textFontWeight: FontWeight.w600,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
