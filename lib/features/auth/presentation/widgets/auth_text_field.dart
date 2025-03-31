import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:melo/core/constants/app_sizes.dart';
import 'package:melo/core/theme/colors.dart';
import 'package:melo/features/auth/presentation/providers/auth_provider.dart';
import 'package:melo/features/auth/presentation/providers/auth_textfield_controllers.dart';

class AuthTextField extends ConsumerWidget {
  final String hint;
  final bool isPassword;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.hint,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authNotifier = ref.read(authControllerProvider.notifier);

    late final TextEditingController controller;

    if (isPassword) {
      controller = ref.watch(passwordControllerProvider);
    } else if (keyboardType == TextInputType.emailAddress) {
      controller = ref.watch(emailControllerProvider);
    } else {
      controller = ref.watch(nameControllerProvider);
    }

    IconData getIcon() {
      if (isPassword) return IconlyLight.lock;
      if (keyboardType == TextInputType.emailAddress) return IconlyLight.message;
      return IconlyLight.profile;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        boxShadow: [
          BoxShadow(
            color: (isDark ? AppColors.primary : AppColors.grey).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        onChanged: (value) {
          if (isPassword) {
            authNotifier.setPassword(value);
          } else if (keyboardType == TextInputType.emailAddress) {
            authNotifier.setEmail(value);
          } else {
            authNotifier.setName(value);
          }
        },
        style: TextStyle(
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            getIcon(),
            color: isDark ? AppColors.primary : AppColors.secondary,
          ),
          hintStyle: TextStyle(
            color: isDark ? AppColors.grey : Colors.grey.shade600,
          ),
          filled: true,
          fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
