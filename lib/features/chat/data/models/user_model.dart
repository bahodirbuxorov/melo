import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    required super.name,
    required super.email,
    required super.avatarUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatarUrl: map['avatarUrl'] ?? '',
    );
  }

  factory UserModel.fromFirebaseUser(dynamic user) {
    return UserModel(uid: user.uid, email: user.email, name: '', avatarUrl: '');
  }
}
