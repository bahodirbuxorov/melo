import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primarySwatch: AppColors.materialPrimary,
    extensions: const [BrandColors.light],
    cardColor: AppColors.lightCard,
    textTheme: _textTheme(AppColors.lightText),
    elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary),
    inputDecorationTheme: _inputDecorationTheme(AppColors.grey),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.lightText,
      titleTextStyle: GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.lightText,
      ),
    ),
    useMaterial3: true,
  );

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primarySwatch: AppColors.materialPrimary,
    extensions: const [BrandColors.dark],
    cardColor: AppColors.darkCard,
    textTheme: _textTheme(AppColors.darkText),
    elevatedButtonTheme: _elevatedButtonTheme(AppColors.primary),
    inputDecorationTheme: _inputDecorationTheme(AppColors.grey),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.darkText,
      titleTextStyle: GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.darkText,
      ),
    ),
    useMaterial3: true,
  );

  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      headlineLarge: GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      bodyMedium: GoogleFonts.urbanist(
        fontSize: 16,
        color: textColor,
      ),
      labelSmall: GoogleFonts.urbanist(
        fontSize: 12,
        color: AppColors.grey,
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(Color color) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.urbanist(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Color hintColor) {
    return InputDecorationTheme(
      hintStyle: GoogleFonts.urbanist(color: hintColor),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}