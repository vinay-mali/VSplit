import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vsplit/widgets/app_text.dart';

void snackBarMessage(BuildContext context, String content) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AppText(text: content, textColor: Colors.white),
    ),
  );
}
