
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(String email, String password, String name) async {
    return repository.register(email, password, name);
  }
}
