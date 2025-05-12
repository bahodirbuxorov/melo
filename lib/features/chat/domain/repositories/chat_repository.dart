import '../entities/chat_entity.dart';
import '../entities/user_entity.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getChatsForUser(String userId);

  Future<ChatEntity> startOrGetChat({
    required String currentUserId,
    required UserEntity otherUser,
  });


  Future<void> deleteChat(String chatId);
}
