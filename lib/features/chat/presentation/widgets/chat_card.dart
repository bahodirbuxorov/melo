import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:melo/core/constants/app_sizes.dart';
import 'package:melo/core/theme/colors.dart';
import 'package:melo/core/theme/text_styles.dart';
import '../../domain/entities/chat_entity.dart';
import '../screens/chat_detail_screen.dart';

class ChatCard extends StatelessWidget {
  final ChatEntity chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = DateFormat.jm().format(chat.updatedAt);

    return InkWell(
      onTap: () {
        context.push(ChatDetailScreen.routeName, extra: chat);
      },
      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p12,
        ),
        margin: const EdgeInsets.symmetric(vertical: Sizes.p8),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.95),
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: chat.contactAvatarUrl.isNotEmpty
                  ? NetworkImage(chat.contactAvatarUrl)
                  : null,
              child: chat.contactAvatarUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: Sizes.p12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.contactName.isNotEmpty
                        ? chat.contactName
                        : chat.contactEmail, // Fallback
                    style: AppTextStyles.headlineMedium(context),
                  ),
                  const SizedBox(height: Sizes.p8),
                  Text(
                    chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall(context).copyWith(
                      color: theme.colorScheme.onBackground.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              time,
              style: AppTextStyles.labelSmall(context),
            ),
          ],
        ),
      ),
    );
  }
}
