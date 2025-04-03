// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'package:http/http.dart' as http;

class FcmService {
  static const String _serverKey = 'BJcq_a5hUjd_AYkRG3lgI3C8FyRbqvkuWaEMcwjV8-R_v90ZrL2jBcK77BPTf8q0F45ekJxw_CC4niW1j_HKuEE'; // 🔑 FCM server key (Firebase Console → Project settings → Cloud Messaging)

  static Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
    required Map<String, String> data,
  }) async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$_serverKey',
    };

    final bodyPayload = jsonEncode({
      'to': token,
      'notification': {
        'title': title,
        'body': body,
        'sound': 'default',
      },
      'data': data, // ✅ Masalan: {'chatId': 'abc123'}
    });

    final response = await http.post(url, headers: headers, body: bodyPayload);

    if (response.statusCode != 200) {
      throw Exception('FCM yuborishda xatolik: ${response.body}');
    }
  }
}
