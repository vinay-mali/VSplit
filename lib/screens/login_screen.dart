import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/providers/auth_user_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController fullNameCtrl = TextEditingController();
  bool obscurePassword = true;
  String _mode = "login";

  void handleLogin() async {
    final authProvider = context.read<AuthUserProvider>();
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please fill all the details.");
      return;
    }
    if (_mode == 'signup' &&
        (usernameCtrl.text.trim().isEmpty ||
            fullNameCtrl.text.trim().isEmpty)) {
      snackBarMessage(context, "Please fill the given fields ");
      return;
    }
    if (_mode == 'signup') {
      final usernameRegex = RegExp(r'^[a-zA-Z0-9_.]{3,20}$');
      if (!usernameRegex.hasMatch(usernameCtrl.text.trim())) {
        snackBarMessage(context, "Username: 3-20 chars, letters/numbers only");
        return;
      }
    }
    try {
      if (_mode == 'login') {
        await authProvider.login(
          emailCtrl.text.trim().toLowerCase(),
          passwordCtrl.text.trim(),
        );
      } else {
        await authProvider.signUp(
          emailCtrl.text.trim().toLowerCase(),
          passwordCtrl.text.trim(),
          usernameCtrl.text.trim(),
          fullNameCtrl.text.trim(),
        );
      }
    } catch (e) {
      if (!mounted) return;
      snackBarMessage(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(_mode == 'login' ? "Login" : "Sign up"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppTheme.reddish,
                                    spreadRadius: 2,
                                    blurRadius: 70,
                                  ),
                                ],
                              ),
                            ),
                            Image.asset(
                              "assets/images/VSplit icon.png",
                              width: 120,
                              height: 120,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_mode == 'signup')
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 13,
                              left: 13,
                              right: 13,
                            ),
                            child: TextField(
                              style: GoogleFonts.poppins(color: Colors.white),
                              controller: usernameCtrl,
                              decoration: InputDecoration(
                                labelText: "Username",
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 13,
                            right: 13,
                            bottom: 10,
                          ),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.poppins(color: Colors.white),
                            controller: emailCtrl,
                            decoration: InputDecoration(labelText: "Email"),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                            left: 13,
                            right: 13,
                            bottom: 10,
                          ),
                          child: TextField(
                            obscureText: obscurePassword,
                            style: GoogleFonts.poppins(color: Colors.white),
                            controller: passwordCtrl,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () => obscurePassword = !obscurePassword,
                                  );
                                },
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_mode == 'signup')
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: TextField(
                              style: GoogleFonts.poppins(color: Colors.white),
                              controller: fullNameCtrl,
                              decoration: InputDecoration(
                                labelText: "Full Name",
                              ),
                            ),
                          ),
                        const SizedBox(height: 25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  context.watch<AuthUserProvider>().isLoading
                                  ? null
                                  : handleLogin,
                              child: context.watch<AuthUserProvider>().isLoading
                                  ? SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : AppText(
                                      text: _mode == 'login'
                                          ? "Login"
                                          : "Sign up",
                                      textColor: Colors.white,
                                      textFontSize: 18,
                                      textFontWeight: FontWeight.w600,
                                    ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _mode = _mode == 'login' ? 'signup' : 'login';
                              emailCtrl.clear();
                              passwordCtrl.clear();
                              usernameCtrl.clear();
                              fullNameCtrl.clear();
                            });
                          },

                          child: AppText(
                            text: _mode == 'login'
                                ? "Don't have an account? Create now"
                                : "Already have an account? Login now",
                            textColor: Colors.white,
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
