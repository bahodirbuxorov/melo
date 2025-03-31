import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/user_model.dart';

class FirebaseUserRepository implements UserRepository {
  final FirebaseFirestore firestore;

  FirebaseUserRepository({required this.firestore});

  @override
  Stream<List<UserEntity>> getAllUsers(String currentUserId) {
    return firestore.collection('users').snapshots().map(
          (snapshot) {
        return snapshot.docs
            .where((doc) => doc.id != currentUserId)
            .map((doc) => UserModel.fromMap(doc.data(), doc.id))
            .toList();
      },
    );
  }
}
