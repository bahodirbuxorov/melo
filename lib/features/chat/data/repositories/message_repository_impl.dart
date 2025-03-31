import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';

class FirebaseMessageRepository implements MessageRepository {
  final FirebaseFirestore firestore;

  FirebaseMessageRepository({required this.firestore});

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) async {
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message.toMap());
  }

  @override
  Stream<List<MessageEntity>> getMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageEntity.fromMap(doc.data(), doc.id))
        .toList());
  }
}
