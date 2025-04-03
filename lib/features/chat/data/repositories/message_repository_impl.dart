import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';

class FirebaseMessageRepository implements MessageRepository {
  final FirebaseFirestore firestore;

  FirebaseMessageRepository({required this.firestore});

  @override
  Future<void> sendMessage(String chatId, MessageEntity message) async {
    // 1. Xabarni saqlash
    await firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    // 2. Chat hujjatini yangilash
    await firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.text,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    // 3. Chatdagi boshqa userlarga push yuborish
    final chatDoc = await firestore.collection('chats').doc(chatId).get();
    final members = List<String>.from(chatDoc.data()?['members'] ?? []);
    final receivers = members.where((id) => id != message.senderId).toList();

    for (final receiverId in receivers) {
      final userDoc = await firestore.collection('users').doc(receiverId).get();
      final fcmToken = userDoc.data()?['fcmToken'];
      if (fcmToken != null && fcmToken.toString().isNotEmpty) {
        await _sendPushNotification(
          token: fcmToken,
          title: 'Yangi xabar',
          body: message.text,
          data: {'chatId': chatId},
        );
      }
    }
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

  /// 🔥 Push notification yuborish (FCM REST API orqali)
  Future<void> _sendPushNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    const serverKey = '05791ddc8608320ac8ef8c04fed30804c496ae88'; // ❗ Web push emas, "Cloud Messaging" dan Server key

    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final payload = jsonEncode({
      'to': token,
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
      },
      'data': data, // {'chatId': chatId}
    });

    final res = await http.post(url, headers: headers, body: payload);
    if (res.statusCode != 200) {
      throw Exception('🔴 FCM yuborishda xatolik: ${res.body}');
    }
  }
}
