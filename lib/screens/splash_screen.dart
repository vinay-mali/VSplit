import 'package:flutter/material.dart';
import 'package:vsplit/widgets/app_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff0f0c29), Color(0xff302b63), Color(0xff24243e)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "assets/images/VSplit icon.png",
                width: 170,
                height: 170,
              ),
            ),

            AppText(
              text: "VSplit",
              textFontSize: 21,
              textFontWeight: FontWeight.w600,
              textColor: Colors.cyanAccent,
            ),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: AppText(
                text: "Splitting bills. Zero drama.",
                textColor: Colors.white,
                textFontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
