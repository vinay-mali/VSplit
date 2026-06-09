import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vsplit/core/themes/app_theme.dart';
import 'package:vsplit/core/utils/helper.dart';
import 'package:vsplit/providers/auth_user_provider.dart';
import 'package:vsplit/widgets/app_text.dart';

class LoginScreen extends StatefulWidget {
  final String mode;
  const LoginScreen({super.key, required this.mode});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController usernameCtrl = TextEditingController();
  bool obscurePassword = true;

  void handleLogin() async {
    final authProvider = context.read<AuthUserProvider>();
    if (emailCtrl.text.trim().isEmpty || passwordCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please fill allthe details.");
      return;
    }
    if (widget.mode == 'signup' && usernameCtrl.text.trim().isEmpty) {
      snackBarMessage(context, "Please enter a username.");
      return;
    }
    try {
      if (widget.mode == 'login') {
        await authProvider.login(
          emailCtrl.text.trim().toLowerCase(),
          passwordCtrl.text.trim(),
        );
      } else {
        await authProvider.signUp(
          emailCtrl.text.trim().toLowerCase(),
          passwordCtrl.text.trim(),
          usernameCtrl.text.trim(),
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
          title: Text(widget.mode == 'login' ? "Login" : "Sign up"),
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
                        if (widget.mode == 'signup')
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
                            bottom: 13,
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
                                      text: widget.mode == 'login'
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
                            if (widget.mode == 'login') {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(mode: 'signup'),
                                ),
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LoginScreen(mode: 'login'),
                                ),
                              );
                            }
                          },
                          child: AppText(
                            text: widget.mode == 'login'
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
