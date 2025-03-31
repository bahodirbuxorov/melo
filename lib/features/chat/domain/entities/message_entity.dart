import 'package:cloud_firestore/cloud_firestore.dart';

class MessageEntity {
  final String id;
  final String senderId;
  final String text;
  final DateTime sentAt;
  final bool isVoice;
  final String? audioUrl;
  final String? mediaUrl;
  final String? mediaType;
  final List<String> seenBy;
  final String? replyToMessageId;
  final String? replyToText;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.text,
    required this.sentAt,
    this.isVoice = false,
    this.audioUrl,
    this.mediaUrl,
    this.mediaType,
    this.seenBy = const [],
    this.replyToMessageId,
    this.replyToText,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': Timestamp.fromDate(sentAt),
      'isVoice': isVoice,
      'audioUrl': audioUrl,
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'seenBy': seenBy,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
    };
  }

  factory MessageEntity.fromMap(Map<String, dynamic> map, String id) {
    final timestamp = map['timestamp'];
    final mediaType = map['mediaType'];
    final mediaUrl = map['mediaUrl'];

    return MessageEntity(
      id: id,
      senderId: map['senderId'] ?? '',
      text: (mediaType == 'image' && mediaUrl != null) ? '' : map['text'] ?? '',
      sentAt: timestamp is Timestamp ? timestamp.toDate() : DateTime.now(),
      isVoice: map['isVoice'] ?? false,
      audioUrl: map['audioUrl'],
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      seenBy: List<String>.from(map['seenBy'] ?? []),
      replyToMessageId: map['replyToMessageId'],
      replyToText: map['replyToText'],
    );
  }
}
