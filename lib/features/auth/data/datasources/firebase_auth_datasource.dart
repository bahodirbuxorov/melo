import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasource(this._auth, this._firestore);

  Future<void> login(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': fcmToken,
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> register(String email, String password, String name) async {
    final result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = result.user;
    if (user != null) {
      final fcmToken = await FirebaseMessaging.instance.getToken();

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'avatarUrl': '',
        'fcmToken': fcmToken,
        'isOnline': true,
        'isTyping': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }


  Future<void> logout() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': FieldValue.delete(),
        'isOnline': false,
        'isTyping': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }

    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();


  Future<void> updateUserPresence({required bool isOnline}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateTypingStatus({required String chatId, required bool isTyping}) async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('typingStatus')
          .doc(user.uid)
          .set({
        'isTyping': isTyping,
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  /// Typing statusni stream sifatida olish
  Stream<bool> getTypingStatus(String chatId, String userId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('typingStatus')
        .doc(userId)
        .snapshots()
        .map((snap) => snap.data()?['isTyping'] ?? false);
  }


  Future<void> updateUserProfile({
    required String name,
    required String bio,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('User not logged in');

    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'bio': bio,
    });
  }

}