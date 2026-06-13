import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:vsplit/widgets/app_text.dart';

class CreateJoinGroupScreen extends StatefulWidget {
  final String mode;
  const CreateJoinGroupScreen({super.key, required this.mode});

  @override
  State<CreateJoinGroupScreen> createState() => _CreateGroupJoinScreenState();
}

class _CreateGroupJoinScreenState extends State<CreateJoinGroupScreen> {
  TextEditingController nameCtrl = TextEditingController();
  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
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
                          padding: const EdgeInsets.symmetric(horizontal: 11),
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
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: AppText(
                              text: widget.mode == 'create' ? "Create" : "Join",
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
