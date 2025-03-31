// lib/features/chat/presentation/screens/chat_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/theme/text_styles.dart';

import '../../../auth/presentation/providers/auth_user_provider.dart';
import '../../../chat/domain/entities/chat_entity.dart';

import '../../../chat/presentation/widgets/message_bubble.dart';
import '../../../chat/presentation/widgets/chat_input_field.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/repositories/message_repository_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';

final messageRepoProvider = Provider<MessageRepository>((ref) {
  return FirebaseMessageRepository(firestore: FirebaseFirestore.instance);
});

final chatMessagesProvider = StreamProvider.family<List<MessageEntity>, String>((ref, chatId) {
  final repo = ref.watch(messageRepoProvider);
  return repo.getMessages(chatId);
});

class ChatDetailScreen extends ConsumerWidget {
  static const routeName = '/chat-detail';
  final ChatEntity chat;
  const ChatDetailScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider).value;
    final messagesAsync = ref.watch(chatMessagesProvider(chat.id));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: chat.contactAvatarUrl.isNotEmpty
                  ? NetworkImage(chat.contactAvatarUrl)
                  : null,
              child: chat.contactAvatarUrl.isEmpty
                  ? const Icon(IconlyLight.profile, color: Colors.grey)
                  : null,
            ),

            const SizedBox(width: 12),
            Text(
              chat.contactName.isNotEmpty
                  ? chat.contactName
                  : chat.contactEmail, // Fallback
              style: AppTextStyles.headlineMedium(context),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                final reversedMessages = messages.reversed.toList(); // 🔁

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reversedMessages.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final msg = reversedMessages[index];
                    final isMine = msg.senderId == user?.uid;
                    return MessageBubble(
                      text: msg.text,
                      isMine: isMine,
                      time: DateFormat.Hm().format(msg.sentAt),
                      isVoice: msg.isVoice,
                      audioUrl: msg.audioUrl,
                    );
                  },
                );
              },

              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Xatolik: $e')),
            ),
          ),
          ChatInputField(chatId: chat.id, senderId: user?.uid ?? ''),
        ],
      ),
    );
  }
}