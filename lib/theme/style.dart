import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Style {
  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.grey[400],
    appBarTheme: AppBarTheme(
      textTheme: GoogleFonts.mondaTextTheme(),
      brightness: Brightness.light,
      elevation: 0,
      color: Colors.white,
    ),
    textTheme: GoogleFonts.mondaTextTheme(),
  );
}