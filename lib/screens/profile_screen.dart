import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/models/user_model.dart';
import 'package:vsplit/providers/auth_user_provider.dart';
import 'package:vsplit/providers/group_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _user;
  bool _loading = true;
  bool _isLoggingOut = false;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  Future<void> getCurrentUser() async {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final user = await context.read<GroupProvider>().getUserById(currentUser);
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    AppText(
                      text: _user!.fullName,
                      textFontSize: 30,
                      textFontWeight: FontWeight.w600,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: AppText(
                        text: "@${_user!.username}",
                        textColor: Colors.grey,
                        textFontSize: 17,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: AppText(
                        text:
                            "Account created on: ${DateFormat('yyyy-MM-dd').format(_user!.dateCreated!)}",
                      ),
                    ),

                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Color(0xff2c2c2c),
                              title: AppText(
                                text: "Are you sure you want to Log out?",
                                textFontSize: 17,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: AppText(text: "Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    setState(() => _isLoggingOut = true);
                                    await context
                                        .read<AuthUserProvider>()
                                        .signOut();
                                    setState(() => _isLoggingOut = false);

                                    if (!mounted) return;
                                    Navigator.pop(context);
                                  },
                                  child: _isLoggingOut
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
                                          text: "Log out",
                                          textFontWeight: FontWeight.w500,
                                        ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: AppText(
                        text: "Log out",
                        textFontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
