// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import '../theme/colors.dart';

enum SnackbarType { success, error, info }

class TopSnackbar extends StatefulWidget {
  final String message;
  final SnackbarType type;

  const TopSnackbar({
    super.key,
    required this.message,
    required this.type,
  });

  static void show(
      BuildContext context, {
        required String message,
        required SnackbarType type,
        Duration duration = const Duration(seconds: 3),
      }) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => TopSnackbar(message: message, type: type),
    );

    overlay.insert(entry);
    Future.delayed(duration, () => entry.remove());
  }

  @override
  State<TopSnackbar> createState() => _TopSnackbarState();
}

class _TopSnackbarState extends State<TopSnackbar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBackgroundColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    switch (widget.type) {
      case SnackbarType.success:
        return brightness == Brightness.dark
            ? AppColors.primary.withOpacity(0.15)
            : AppColors.primary.withOpacity(0.1);
      case SnackbarType.error:
        return brightness == Brightness.dark
            ? AppColors.accent.withOpacity(0.15)
            : AppColors.accent.withOpacity(0.1);
      case SnackbarType.info:
        return brightness == Brightness.dark
            ? AppColors.secondary.withOpacity(0.15)
            : AppColors.secondary.withOpacity(0.1);
    }
  }

  Color _getTextColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? AppColors.darkText : AppColors.lightText;
  }

  IconData _getIcon() {
    switch (widget.type) {
      case SnackbarType.success:
        return IconlyLight.tick_square;
      case SnackbarType.error:
        return IconlyLight.danger;
      case SnackbarType.info:
        return IconlyLight.info_circle;
    }
  }

  Color _getIconColor() {
    switch (widget.type) {
      case SnackbarType.success:
        return AppColors.primary;
      case SnackbarType.error:
        return AppColors.accent;
      case SnackbarType.info:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: _getBackgroundColor(context),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _getIcon(),
                    color: _getIconColor(),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.message,
                      style: GoogleFonts.urbanist(
                        color: _getTextColor(context),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
