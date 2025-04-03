import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/theme/colors.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.accent, AppColors.primary],
          ).createShader(bounds),
          child: const Icon(
            IconlyBold.profile,
            size: 48,
            color: Colors.white,
          ),
        ).animate().slideX(begin: -1).fadeIn(duration: 600.ms),

        const SizedBox(height: 20),

        Text(
          'Welcome!',
          style: GoogleFonts.urbanist(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            // ignore: deprecated_member_use
            color: theme.colorScheme.onBackground,
          ),
        ).animate().slideY(begin: 0.3).fadeIn(duration: 400.ms),

        const SizedBox(height: 8),

        Text(
          'Let’s get you started.',
          style: GoogleFonts.urbanist(
            fontSize: 16,
            // ignore: deprecated_member_use
            color: theme.colorScheme.onBackground.withOpacity(0.9),
          ),
        ).animate().fadeIn(duration: 500.ms, delay: 100.ms),
      ],
    );
  }
}
