import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:melo/core/constants/app_sizes.dart';
import 'package:melo/core/theme/text_styles.dart';
import '../../domain/entities/chat_entity.dart';
import '../screens/chat_detail_screen.dart';
import '../provider/chat_providers.dart'; // <-- deleteChatProvider uchun

class ChatCard extends ConsumerWidget {
  final ChatEntity chat;

  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final time = DateFormat.jm().format(chat.updatedAt);

    return Dismissible(
      key: ValueKey(chat.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Sizes.p24),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Chatni o‘chirish'),
            content: const Text('Bu chatni butunlay o‘chirmoqchimisiz?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Bekor qilish')),
              TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('O‘chirish')),
            ],
          ),
        );
      },
      onDismissed: (_) async {
        await ref.read(chatRepositoryProvider).deleteChat(chat.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chat o‘chirildi')),
        );
      },
      child: InkWell(
        onTap: () => context.push(ChatDetailScreen.routeName, extra: chat),
        borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: Sizes.p8),
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16, vertical: Sizes.p12),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.95),
            borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black26 : Colors.black12,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade300,
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
                          : chat.contactEmail,
                      style: AppTextStyles.headlineMedium(context),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall(context).copyWith(
                        color: isDark ? Colors.white70 : Colors.black.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Sizes.p8),
              Text(
                time,
                style: AppTextStyles.labelSmall(context).copyWith(
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
