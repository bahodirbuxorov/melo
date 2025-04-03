// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/colors.dart';
import '../constants/app_sizes.dart';

class ReusableButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final double borderRadius;
  final double height;
  final TextStyle? textStyle;
  final Gradient? gradient;

  const ReusableButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isEnabled = true,
    this.borderRadius = Sizes.borderRadiusLg,
    this.height = 52,
    this.textStyle,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final defaultGradient = LinearGradient(
      colors: isDark
          ? [AppColors.primary.withOpacity(0.9), AppColors.secondary.withOpacity(0.9)]
          : [AppColors.primary, AppColors.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final effectiveGradient = isEnabled ? (gradient ?? defaultGradient) : null;

    return GestureDetector(
      onTap: isEnabled ? onPressed : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1 : 0.6,
        child: Container(
          width: double.infinity,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            color: effectiveGradient == null
                ? (isDark ? Colors.grey.shade800 : Colors.grey.shade300)
                : null,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              if (isEnabled)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Text(
            label,
            style: textStyle ??
                GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isEnabled ? Colors.white : Colors.grey,
                ),
          ),
        ),
      ),
    );
  }
}
