import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.text,
    required super.sentAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map, String docId) {
    final timestamp = map['timestamp'];
    return MessageModel(
      id: docId,
      senderId: map['senderId'] ?? '',
      text: map['text'] ?? '',
      sentAt: timestamp is Timestamp
          ? timestamp.toDate()
          : DateTime.tryParse(timestamp.toString()) ?? DateTime.now(),
    );
  }

  @override
  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'timestamp': Timestamp.fromDate(sentAt),
  };
}
