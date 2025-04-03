// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:melo/core/theme/colors.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  const FullImageScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.black : Colors.black.withOpacity(0.95),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.grey.shade300),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Hero(
            tag: imageUrl,
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 1.0,
              maxScale: 4.0,
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/image_placeholder.png', // optional placeholder
                image: imageUrl,
                fit: BoxFit.contain,
                fadeInDuration: const Duration(milliseconds: 300),
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 60, color: Colors.grey);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
