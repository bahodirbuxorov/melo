import '../../../chat/domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/firebase_auth_datasource.dart';
import '../../../chat/data/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource datasource;

  AuthRepositoryImpl(this.datasource);

  @override
  Future<void> login(String email, String password) =>
      datasource.login(email, password);


  @override
  Future<void> register(String email, String password, String name) {
    return datasource.register(email, password, name);
  }

  @override
  Future<void> logout() => datasource.logout();

  @override
  Stream<UserEntity?> get user =>
      datasource.user.map((user) =>
      user != null ? UserModel.fromFirebaseUser(user) : null);

  @override
  Future<void> updateUserProfile({required String name, required String bio}) {
    return datasource.updateUserProfile(name: name, bio: bio);
  }

}

