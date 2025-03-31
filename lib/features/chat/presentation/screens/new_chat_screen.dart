import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/presentation/providers/auth_user_provider.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../provider/chat_providers.dart';
import '../provider/user_repository_provider.dart';
import '../widgets/user_tile.dart';
import 'chat_detail_screen.dart';

class NewChatScreen extends ConsumerWidget {
  const NewChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);
    final currentUser = ref.watch(authUserProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Chat"),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.main),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: usersAsync.when(
          loading: () => const LoadingIndicator(),
          error: (e, _) => Center(child: Text("Xatolik: $e")),
          data: (List<UserEntity> users) {
            final filtered = users.where((u) => u.uid != currentUser?.uid).toList();

            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final selectedUser = filtered[index];
                return UserTile(
                  user: selectedUser,
                  onTap: () async {
                    final repo = ref.read(chatRepositoryProvider);
                    final chat = await repo.startOrGetChat(
                      currentUserId: currentUser!.uid,
                      otherUser: selectedUser,
                    );
                    context.push(ChatDetailScreen.routeName, extra: chat);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
