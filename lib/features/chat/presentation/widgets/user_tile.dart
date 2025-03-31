import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/colors.dart';
import '../../domain/entities/user_entity.dart';

class UserTile extends StatelessWidget {
  final UserEntity user;
  final VoidCallback onTap;

  const UserTile({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      child: Container(
        padding: const EdgeInsets.all(Sizes.p12),
        margin: const EdgeInsets.symmetric(vertical: Sizes.p8),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: user.avatarUrl.isNotEmpty
                  ? NetworkImage(user.avatarUrl)
                  : null,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: user.avatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: Sizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name.isNotEmpty ? user.name : user.email,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    user.email,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
