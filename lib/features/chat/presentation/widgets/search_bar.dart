import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/constants/app_sizes.dart';

class ChatSearchBar extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const ChatSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.hintText = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.ltr, // 👈 bu muammoni yechadi
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.textTheme.bodyMedium?.color,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: theme.hintColor,
        ),
        prefixIcon: const Icon(IconlyLight.search),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(
          vertical: Sizes.p12,
          horizontal: Sizes.p16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.5),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
