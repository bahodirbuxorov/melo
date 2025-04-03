// lib/features/chat/data/models/chat_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/chat_entity.dart';

class ChatModel extends ChatEntity {
  ChatModel({
    required super.id,
    required super.lastMessage,
    required super.contactName,
    required super.contactAvatarUrl,
    required super.updatedAt,
    required super.contactEmail, required super.members, required super.contactId,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map, String docId) {
    return ChatModel(
      id: docId,
      lastMessage: map['lastMessage'] ?? '',
      contactName: map['contactName'] ?? '',
      contactAvatarUrl: map['contactAvatarUrl'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      // qo‘shildi
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(), members: [], contactId: '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'lastMessage': lastMessage,
      'contactName': contactName,
      'contactAvatarUrl': contactAvatarUrl,
      'contactEmail': contactEmail,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}