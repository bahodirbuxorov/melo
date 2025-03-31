import 'package:flutter/material.dart';

/// App-wide color constants and gradients grouped by theme.
abstract class AppColors {
  // Modern primary colors
  static const Color primary = Color(0xFF715AFF); // Indigo-Violet fusion
  static const Color secondary = Color(0xFFFF9680); // Soft Coral
  static const Color accent = Color(0xFF00D1FF); // Bright Cyan

  // Greys & Neutrals
  static const Color grey = Color(0xFFB0B0B0);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0E0E10);

  // Light theme
  static const Color lightBackground = Color(0xFFF6F8FF); // Almost white-blue
  static const Color lightText = Color(0xFF1A1B1F); // Dark Charcoal
  static const Color lightCard = Color(0xFFFFFFFF);

  // Dark theme
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkText = Color(0xFFEDEDED);
  static const Color darkCard = Color(0xFF1E1E28); // Deep greyish blue

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
