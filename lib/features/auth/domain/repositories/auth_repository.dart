import '../../../chat/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> register(String email, String password, String name);
  Future<void> logout();
  Stream<UserEntity?> get user;
  Future<void> updateUserProfile({required String name, required String bio}); // ✅ ADD
}
