  import 'package:cloud_firestore/cloud_firestore.dart';
  import '../../domain/entities/chat_entity.dart';
  import '../../domain/entities/user_entity.dart';
  import '../../domain/repositories/chat_repository.dart';
  import '../models/chat_model.dart';

  class FirebaseChatRepository implements ChatRepository {
    final FirebaseFirestore firestore;

    FirebaseChatRepository({required this.firestore});

    @override
    Stream<List<ChatEntity>> getChatsForUser(String userId) {
      return firestore
          .collection('chats')
          .where('members', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .asyncMap((snapshot) async {
        final List<ChatEntity> chats = [];

        for (final doc in snapshot.docs) {
          final data = doc.data();
          final members = List<String>.from(data['members'] ?? []);
          final otherUserId = members.firstWhere((id) => id != userId);

          final userDoc = await firestore.collection('users').doc(otherUserId).get();
          final userData = userDoc.data() ?? {};

          chats.add(ChatEntity(
            id: doc.id,
            lastMessage: data['lastMessage'] ?? '',
            contactName: userData['name'] ?? '',
            contactAvatarUrl: userData['avatarUrl'] ?? '',
            contactEmail: userData['email'] ?? '',
            updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
          ));
        }

        return chats;
      });
    }

    @override
    Future<ChatEntity> startOrGetChat({
      required String currentUserId,
      required UserEntity otherUser,
    }) async {
      final members = [currentUserId, otherUser.uid]..sort();
      final query = await firestore
          .collection('chats')
          .where('members', isEqualTo: members)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        return ChatEntity(
          id: query.docs.first.id,
          lastMessage: data['lastMessage'] ?? '',
          contactName: otherUser.name,
          contactAvatarUrl: otherUser.avatarUrl,
          contactEmail: otherUser.email,
          updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }

      final docRef = await firestore.collection('chats').add({
        'members': members,
        'lastMessage': '',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return ChatEntity(
        id: docRef.id,
        lastMessage: '',
        contactName: otherUser.name,
        contactAvatarUrl: otherUser.avatarUrl,
        contactEmail: otherUser.email,
        updatedAt: DateTime.now(),
      );
    }
  }