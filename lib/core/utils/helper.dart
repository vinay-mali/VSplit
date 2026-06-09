import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vsplit/widgets/app_text.dart';

void snackBarMessage(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppText(text: content, textColor: Colors.white),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color(0xff2c2c2c),
      duration: const Duration(seconds: 3),
    ),
  );
}
