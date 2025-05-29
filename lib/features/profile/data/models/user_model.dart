import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../chat/domain/entities/user_entity.dart';

class UserModel implements UserEntity {
  @override
  final String uid;
  @override
  final String name;
  @override
  final String email;
  @override
  final String avatarUrl;
  @override
  final bool isOnline;
  @override
  final DateTime? lastSeen;
  @override
  final String bio;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isOnline,
    required this.lastSeen,
    required this.bio,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
      isOnline: map['isOnline'] ?? false,
      lastSeen: (map['lastSeen'] as Timestamp?)?.toDate(),
      bio: map['bio'] ?? '',
    );
  }
}
