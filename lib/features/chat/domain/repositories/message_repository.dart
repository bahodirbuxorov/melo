import '../entities/message_entity.dart';

abstract class MessageRepository {
  Future<void> sendMessage(String chatId, MessageEntity message);
  Stream<List<MessageEntity>> getMessages(String chatId);
}

