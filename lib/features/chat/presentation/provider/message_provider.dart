import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../chat/data/repositories/message_repository_impl.dart';
import '../../../chat/domain/entities/message_entity.dart';
import '../../../chat/domain/repositories/message_repository.dart';

final messageRepoProvider = Provider<MessageRepository>((ref) {
  return FirebaseMessageRepository(firestore: FirebaseFirestore.instance);
});

final chatMessagesProvider = StreamProvider.family<List<MessageEntity>, String>((ref, chatId) {
  final repo = ref.watch(messageRepoProvider);
  return repo.getMessages(chatId);
});
