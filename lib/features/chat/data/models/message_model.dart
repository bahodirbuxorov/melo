import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required String id,
    required String senderId,
    required String text,
    required DateTime sentAt,
  }) : super(
    id: id,
    senderId: senderId,
    text: text,
    sentAt: sentAt,
  );

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

  Map<String, dynamic> toMap() => {
    'senderId': senderId,
    'text': text,
    'timestamp': Timestamp.fromDate(sentAt),
  };
}
