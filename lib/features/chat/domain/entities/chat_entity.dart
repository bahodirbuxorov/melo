class ChatEntity {
  final String id;
  final String lastMessage;
  final String contactName;
  final String contactAvatarUrl;
  final String contactEmail;
  final DateTime updatedAt;

  ChatEntity({
    required this.id,
    required this.lastMessage,
    required this.contactName,
    required this.contactAvatarUrl,
    required this.contactEmail,
    required this.updatedAt,
  });
}
