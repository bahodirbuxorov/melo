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

import '../widgets/search_bar.dart'; // renamed and imported

final chatSearchQueryProvider = StateProvider<String>((ref) => '');

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(chatSearchQueryProvider);
    _controller = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatListAsync = ref.watch(chatListProvider);
    final query = ref.watch(chatSearchQueryProvider);
    final theme = Theme.of(context);

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
          child: Column(
            children: [
              const SizedBox(height: Sizes.p16),

              ChatSearchBar(
                controller: _controller,
                hintText: 'Chat nomini yozing...',
                onChanged: (val) =>
                ref.read(chatSearchQueryProvider.notifier).state = val,
              ),

              const SizedBox(height: Sizes.p16),

              Expanded(
                child: chatListAsync.when(
                  loading: () => ListView.separated(
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
                    final filteredChats = chats
                        .where((chat) =>
                        chat.name.toLowerCase().contains(query.toLowerCase()))
                        .toList();

                    if (filteredChats.isEmpty) {
                      return Center(
                        child: Text(
                          'Chat topilmadi.',
                          style: AppTextStyles.bodySmall(context).copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: filteredChats.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: Sizes.p12),
                      itemBuilder: (context, index) {
                        final chat = filteredChats[index];
                        return ChatCard(chat: chat);
                      },
                    );
                  },
                ),
              ),
            ],
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
