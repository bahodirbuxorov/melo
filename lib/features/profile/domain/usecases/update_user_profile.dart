import '../../../auth/domain/repositories/auth_repository.dart';

class UpdateUserProfile {
  final AuthRepository repo;

  UpdateUserProfile(this.repo);

  Future<void> call(String name, String bio) async {
    await repo.updateUserProfile(name: name, bio: bio);
  }
}


