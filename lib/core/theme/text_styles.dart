import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.black,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 14,
      color: Theme.of(context).textTheme.bodyMedium?.color ?? AppColors.black,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.urbanist(
      fontSize: 12,
      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5) ?? AppColors.grey,
    );
  }

  // Existing full text theme (optional)
  static TextTheme textTheme(BuildContext context) {
    final color = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;

    return TextTheme(
      headlineLarge: GoogleFonts.urbanist(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      bodyMedium: GoogleFonts.urbanist(
        fontSize: 16,
        color: color,
      ),
      labelSmall: GoogleFonts.urbanist(
        fontSize: 12,
        color: Colors.grey,
      ),
    );
  }
}
