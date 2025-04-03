import 'package:cloud_firestore/cloud_firestore.dart';

class ChatEntity {
  final String id;
  final List<String> members;
  final String contactId; // ✅ Qo‘shildi
  final String contactName;
  final String contactEmail;
  final String contactAvatarUrl;
  final DateTime updatedAt;
  final String lastMessage;

  ChatEntity({
    required this.id,
    required this.members,
    required this.contactId, // ✅ Qo‘shildi
    required this.contactName,
    required this.contactEmail,
    required this.contactAvatarUrl,
    required this.updatedAt,
    required this.lastMessage,
  });

  factory ChatEntity.fromMap(Map<String, dynamic> map, String id) {
    return ChatEntity(
      id: id,
      members: List<String>.from(map['members'] ?? []),
      contactId: map['contactId'] ?? '', // ✅ Qo‘shildi
      contactName: map['contactName'] ?? '',
      contactEmail: map['contactEmail'] ?? '',
      contactAvatarUrl: map['contactAvatarUrl'] ?? '',
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastMessage: map['lastMessage'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'members': members,
      'contactId': contactId, // ✅ Qo‘shildi
      'contactName': contactName,
      'contactEmail': contactEmail,
      'contactAvatarUrl': contactAvatarUrl,
      'updatedAt': Timestamp.fromDate(updatedAt),
      'lastMessage': lastMessage,
    };
  }
}
