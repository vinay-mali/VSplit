import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vsplit/screens/login_screen.dart';
import 'package:vsplit/screens/main_screen.dart';
import 'package:vsplit/screens/splash_screen.dart';
import 'package:vsplit/widgets/app_text.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
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
