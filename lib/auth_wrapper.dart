import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/screens/auth/splash_screen.dart';
import 'package:vsplit/screens/auth/login_screen.dart';
import 'package:vsplit/screens/auth/main_screen.dart';
import 'package:vsplit/widgets/app_text.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _showSplash = true;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSplash) return SplashScreen();

    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: AppText(
                text: "Something went wrong. Please try again",
                textColor: Colors.white,
              ),
            ),
          );
        }
        if (!snapshot.hasData) {
          return LoginScreen();
        }
        return MainScreen();
      },
    );
  }
}
