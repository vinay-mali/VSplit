import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/providers/group_provider.dart';

import 'package:vsplit/widgets/app_text.dart';

class CreateJoinGroupScreen extends StatefulWidget {
  final String mode;
  const CreateJoinGroupScreen({super.key, required this.mode});

  @override
  State<CreateJoinGroupScreen> createState() => _CreateGroupJoinScreenState();
}

class _CreateGroupJoinScreenState extends State<CreateJoinGroupScreen> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController currencyCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  Future<void> createGroup() async {
    if (nameCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please enter the Group Name");
      return;
    }
    try {
      await context.read<GroupProvider>().createGroup(
        nameCtrl.text.trim(),
        currencyCtrl.text.trim(),
        descriptionCtrl.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      snackBarMessage(context, e.toString());
    }
  }

  Future<void> joinGroup() async {
    if (nameCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please enter the code name");
      return;
    }
    try {
      await context.read<GroupProvider>().joinGroups(
        nameCtrl.text.trim().toUpperCase(),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      snackBarMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.mode == 'create' ? "Create Group" : "Join Group"),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 5,
                          ),
                          child: TextField(
                            style: GoogleFonts.poppins(color: Colors.white),
                            controller: nameCtrl,
                            decoration: InputDecoration(
                              labelText: widget.mode == 'create'
                                  ? "Group Name"
                                  : "Enter Code",
                            ),
                          ),
                        ),
                        if (widget.mode == 'create')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(color: Colors.white),

                              controller: descriptionCtrl,
                              decoration: InputDecoration(
                                labelText: "Description (optional)",
                              ),
                            ),
                          ),
                        if (widget.mode == 'create')
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 5,
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(color: Colors.white),

                              controller: currencyCtrl,
                              decoration: InputDecoration(
                                labelText: "Currency (optional)",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton(
                                    dropdownColor: const Color.fromARGB(
                                      255,
                                      56,
                                      55,
                                      55,
                                    ),
                                    iconEnabledColor: Colors.white,
                                    iconSize: 30,
                                    items: ["₹", r"$", "€", "£", "¥"].map((
                                      currency,
                                    ) {
                                      return DropdownMenuItem(
                                        value: currency,
                                        child: AppText(text: currency),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        currencyCtrl.text = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed:
                                context.watch<GroupProvider>().isCreating ||
                                    context.watch<GroupProvider>().isJoining
                                ? null
                                : widget.mode == 'create'
                                ? createGroup
                                : joinGroup,
                            child: context.watch<GroupProvider>().isCreating
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : AppText(
                                    text: widget.mode == 'create'
                                        ? "Create"
                                        : "Join",
                                    textColor: Colors.white,
                                    textFontSize: 17,
                                    textFontWeight: FontWeight.w500,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
