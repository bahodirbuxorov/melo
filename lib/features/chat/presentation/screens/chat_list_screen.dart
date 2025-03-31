import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/chat_entity.dart';
import '../provider/chat_providers.dart';
import '../widgets/chat_card.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppGradients.main,
        ),
        child: chatListAsync.when(
          loading: () => const LoadingIndicator(),
          error: (err, _) => Center(child: Text('Xatolik: $err')),
          data: (List<ChatEntity> chats) {
            if (chats.isEmpty) {
              return const Center(
                child: Text(
                  'Hech qanday chat mavjud emas.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p16,
                vertical: Sizes.p8,
              ),
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatCard(chat: chat);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/new-chat'); // yoki NewChatScreen.routeName
        },
        child: const Icon(IconlyLight.chat),
      ),

    );
  }
}
