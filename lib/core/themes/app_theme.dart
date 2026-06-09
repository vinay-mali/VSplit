import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFFFF007F);
  static const Color darkBg = Color(0xff121212);
  static const Color green = Color(0xff7dff95);
  static const Color goldenish = Color(0xffffbc5e);
  static const Color reddish = Color(0xffff8080);
  static const Color skybluish = Color(0xff87d1ff);

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(
      titleTextStyle: GoogleFonts.poppins(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      backgroundColor: darkBg,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      surface: darkBg,
      primary: primaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.poppins(color: Colors.white),
      ),
    ),
    inputDecorationTheme: InputDecorationThemeData(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: skybluish),
      ),
      labelStyle: GoogleFonts.poppins(color: Colors.grey),
      hintStyle: GoogleFonts.poppins(color: Colors.grey),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentTextStyle: GoogleFonts.poppins(color: Colors.white),
    ),
  );
}
