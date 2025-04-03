import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../domain/entities/chat_entity.dart';
import '../provider/chat_providers.dart';
import '../widgets/chat_card.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListProvider);
    final theme = Theme.of(context);
    final _ = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.main),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.p16),
          child: chatListAsync.when(
            loading: () => ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(height: Sizes.p12),
              itemBuilder: (_, __) => const ReusableShimmerTile(),
            ),
            error: (err, _) => Center(
              child: Text(
                'Xatolik: $err',
                style: AppTextStyles.bodySmall(context),
              ),
            ),
            data: (List<ChatEntity> chats) {
              if (chats.isEmpty) {
                return Center(
                  child: Text(
                    'Hech qanday chat mavjud emas.',
                    style: AppTextStyles.bodySmall(context).copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p16),
                itemCount: chats.length,
                separatorBuilder: (_, __) => const SizedBox(height: Sizes.p12),
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ChatCard(chat: chat);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new-chat'),
        backgroundColor: theme.primaryColor,
        child: const Icon(IconlyLight.chat),
      ),
    );
  }
}
