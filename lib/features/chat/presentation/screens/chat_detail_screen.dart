// lib/features/chat/presentation/screens/chat_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:iconly/iconly.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../auth/presentation/providers/auth_user_provider.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/message_repository_impl.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/message_repository.dart';
import '../widgets/chat_input_field.dart';
import '../widgets/message_bubble.dart';

final messageRepoProvider = Provider<MessageRepository>((ref) {
  return FirebaseMessageRepository(firestore: FirebaseFirestore.instance);
});

final chatMessagesProvider =
StreamProvider.family<List<MessageEntity>, String>((ref, chatId) {
  final repo = ref.watch(messageRepoProvider);
  return repo.getMessages(chatId);
});

final chatByIdProvider =
FutureProvider.family<ChatEntity?, String>((ref, chatId) async {
  final doc =
  await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
  if (!doc.exists) return null;
  final data = doc.data()!;
  return ChatEntity.fromMap(data, doc.id);
});

final isTypingProvider =
StreamProvider.family<bool, String>((ref, chatId) async* {
  final currentUser = ref.watch(authUserProvider).value;
  if (currentUser == null) return;

  yield* FirebaseFirestore.instance
      .collection('chats')
      .doc(chatId)
      .collection('typing')
      .snapshots()
      .map((snap) {
    for (var doc in snap.docs) {
      if (doc.id != currentUser.uid && doc['isTyping'] == true) {
        return true;
      }
    }
    return false;
  });
});

final userStatusProvider =
StreamProvider.family<UserEntity, String>((ref, userId) {
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .map((doc) => UserModel.fromMap(doc.data()!, doc.id));
});

class ChatDetailScreen extends ConsumerWidget {
  static const routeName = '/chat-detail';
  final String? chatId;
  final ChatEntity? chat;

  const ChatDetailScreen({
    super.key,
    this.chatId,
    this.chat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authUserProvider).value;

    if (chat != null) {
      return _ChatUI(chat: chat!, userId: currentUser?.uid ?? '');
    } else if (chatId != null) {
      final asyncChat = ref.watch(chatByIdProvider(chatId!));
      return asyncChat.when(
        data: (chat) {
          if (chat == null) {
            return const Scaffold(body: Center(child: Text('Chat topilmadi')));
          }
          return _ChatUI(chat: chat, userId: currentUser?.uid ?? '');
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Xatolik: \$e'))),
      );
    } else {
      return const Scaffold(body: Center(child: Text('Noto‘g‘ri chat parametri')));
    }
  }
}

class _ChatUI extends ConsumerWidget {
  final ChatEntity chat;
  final String userId;

  const _ChatUI({required this.chat, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(chatMessagesProvider(chat.id));
    final contactId = chat.members.firstWhere((id) => id != userId);
    final userStatusAsync = ref.watch(userStatusProvider(contactId));
    final _ = ref.watch(isTypingProvider(chat.id));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: chat.contactAvatarUrl.isNotEmpty
                  ? NetworkImage(chat.contactAvatarUrl)
                  : null,
              child: chat.contactAvatarUrl.isEmpty
                  ? const Icon(IconlyLight.profile, color: Colors.grey)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.contactName.isNotEmpty
                      ? chat.contactName
                      : chat.contactEmail,
                  style: AppTextStyles.headlineMedium(context),
                ),
                userStatusAsync.when(
                  data: (user) {
                    if (user.isOnline) {
                      return const Text(
                        "Online",
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      );
                    } else {
                      final lastSeenText = user.lastSeen != null
                          ? DateFormat('HH:mm').format(user.lastSeen!)
                          : "Unknown";

                      return Text(
                        "Last seen: $lastSeenText",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      );
                    }
                  },
                  loading: () => const Text("Loading...", style: TextStyle(fontSize: 12)),
                  error: (_, __) => const SizedBox(),
                )

              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                final reversed = messages.reversed.toList();
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  reverse: true,
                  itemCount: reversed.length,
                  itemBuilder: (context, index) {
                    final msg = reversed[index];
                    final isMine = msg.senderId == userId;
                    return MessageBubble(
                      text: msg.text,
                      isMine: isMine,
                      time: DateFormat.Hm().format(msg.sentAt),
                      isVoice: msg.isVoice,
                      audioUrl: msg.audioUrl,
                      mediaUrl: msg.mediaUrl,
                      mediaType: msg.mediaType,
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                padding: const EdgeInsets.all(16),
                reverse: true,
                itemCount: 6,
                itemBuilder: (_, __) => const ReusableShimmerTile(
                  avatarSize: 0,
                  titleWidth: 160,
                  subtitleWidth: 100,
                  height: 80,
                  radius: 20,
                  showTrailing: false,
                ),
              ),
              error: (e, _) => Center(child: Text('Xatolik: \$e')),
            ),
          ),
          ChatInputField(chatId: chat.id, senderId: userId),
        ],
      ),
    );
  }
}
