import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/colors.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final _ = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
          ).createShader(bounds),
          child: const Icon(
            IconlyBold.login,
            size: 48,
            color: Colors.white, // Gradient bu yerda o‘rnini bosadi
          ),
        ).animate().slideX(begin: -1, duration: 600.ms).fadeIn(),

        const SizedBox(height: 20),

        Text(
          AppStrings.loginTitle,
          style: GoogleFonts.urbanist(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            // ignore: deprecated_member_use
            color: theme.colorScheme.onBackground,
          ),
        ).animate().slideY(begin: 0.4).fadeIn(duration: 400.ms),

        const SizedBox(height: 8),

        Text(
          AppStrings.loginSubtitle,
          style: GoogleFonts.urbanist(
            fontSize: 16,
            // ignore: deprecated_member_use
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
      ],
    );
  }
}
