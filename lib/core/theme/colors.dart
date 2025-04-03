import 'package:flutter/material.dart';

/// App-wide color constants and gradients grouped by theme.
abstract class AppColors {
  // Material primary swatch (used in ThemeData)
  static const MaterialColor materialPrimary = MaterialColor(
    0xFF715AFF,
    <int, Color>{
      50: Color(0xFFF2EEFF),
      100: Color(0xFFD8CEFF),
      200: Color(0xFFBFAEFF),
      300: Color(0xFFA58EFF),
      400: Color(0xFF8C6EFF),
      500: Color(0xFF715AFF),
      600: Color(0xFF5A49CC),
      700: Color(0xFF443699),
      800: Color(0xFF2D2566),
      900: Color(0xFF171233),
    },
  );

  // Brand colors
  static const Color primary = Color(0xFF715AFF); // Indigo-Violet fusion
  static const Color secondary = Color(0xFFFF9680); // Soft Coral
  static const Color accent = Color(0xFF00D1FF); // Bright Cyan

  // Greys & Neutrals
  static const Color grey = Color(0xFFB0B0B0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0E0E10);

  // Light theme
  static const Color lightBackground = Color(0xFFF6F8FF);
  static const Color lightText = Color(0xFF1A1B1F);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Color(0xFFEDEDED);
  static const Color darkCard = Color(0xFF1E1E28);

  // Gradients
  static const Gradient lightGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [Color(0xFF2D2D3A), Color(0xFF1C1C24)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}

/// ThemeExtension for custom brand colors (for dynamic theming if needed)
@immutable
class BrandColors extends ThemeExtension<BrandColors> {
  final Color primary;
  final Color secondary;
  final Color accent;

  const BrandColors({
    required this.primary,
    required this.secondary,
    required this.accent,
  });

  static const light = BrandColors(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
  );

  static const dark = BrandColors(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    accent: AppColors.accent,
  );

  @override
  BrandColors copyWith({
    Color? primary,
    Color? secondary,
    Color? accent,
  }) {
    return BrandColors(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
    );
  }

  @override
  BrandColors lerp(ThemeExtension<BrandColors>? other, double t) {
    if (other is! BrandColors) return this;
    return BrandColors(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
    );
  }
}