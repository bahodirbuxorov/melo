import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ReusableShimmerTile extends StatelessWidget {
  final double avatarSize;
  final double titleWidth;
  final double subtitleWidth;
  final double height;
  final double radius;
  final bool showTrailing;

  const ReusableShimmerTile({
    super.key,
    this.avatarSize = 48,
    this.titleWidth = 120,
    this.subtitleWidth = 80,
    this.height = 72,
    this.radius = 16,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎨 Custom colors for shimmer
    final baseColor = isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE0E0E0);
    final highlightColor = isDark ? const Color(0xFF3C3C3E) : const Color(0xFFF5F5F5);
    final shimmerChildColor = isDark ? Colors.grey.shade900 : Colors.grey.shade200;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: shimmerChildColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
          children: [
            // Avatar shimmer
            Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: baseColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            // Title + Subtitle shimmer
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: titleWidth,
                    height: 12,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: subtitleWidth,
                    height: 10,
                    decoration: BoxDecoration(
                      color: baseColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            if (showTrailing) ...[
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 10,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
