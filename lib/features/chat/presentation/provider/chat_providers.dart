  // lib/features/chat/presentation/providers/chat_providers.dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../../../auth/presentation/providers/auth_user_provider.dart';
  import '../../../chat/data/repositories/chat_repository_impl.dart';
  import '../../../chat/domain/entities/chat_entity.dart';
  import '../../../chat/domain/repositories/chat_repository.dart';

  final chatRepositoryProvider = Provider<ChatRepository>((ref) {
    return FirebaseChatRepository(firestore: FirebaseFirestore.instance);
  });

  final chatListProvider = StreamProvider<List<ChatEntity>>((ref) {
    final user = ref.watch(authUserProvider).value;
    final repository = ref.watch(chatRepositoryProvider);

    if (user == null) return const Stream.empty();
    return repository.getChatsForUser(user.uid);
  });
