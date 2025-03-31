import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/local_storage_provider.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

import 'auth_state.dart';
import 'auth_provider.dart';

class AuthController extends Notifier<AuthState> {
  late final LoginUseCase _loginUseCase;
  late final RegisterUseCase _registerUseCase;

  @override
  AuthState build() {
    _loginUseCase = ref.read(loginUseCaseProvider);
    _registerUseCase = ref.read(registerUseCaseProvider);
    return AuthState.initial();
  }

  void setEmail(String value) {
    state = state.copyWith(email: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }
  void setName(String value) {
    state = state.copyWith(name: value);
  }

  Future<void> register() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _registerUseCase(
        state.email.trim(),
        state.password.trim(),
        state.name.trim(), // ✅ Name ni uzatamiz
      );

      final storage = ref.read(localStorageProvider);
      await storage.saveEmail(state.email.trim());
      await storage.setRememberMe(true);
    } catch (e) {
      state = state.copyWith(errorMessage: _mapErrorMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }


  Future<void> login() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _loginUseCase(state.email.trim(), state.password.trim());

      // ✅ Login muvaffaqiyatli bo‘lsa:
      final storage = ref.read(localStorageProvider);
      await storage.saveEmail(state.email.trim());
      await storage.setRememberMe(true);

    } catch (e) {
      state = state.copyWith(errorMessage: _mapErrorMessage(e));
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }



  String _mapErrorMessage(dynamic e) {
    final error = e.toString();
    if (error.contains('user-not-found')) return 'Foydalanuvchi topilmadi';
    if (error.contains('wrong-password')) return 'Parol noto‘g‘ri';
    if (error.contains('email-already-in-use')) return 'Email band';
    if (error.contains('invalid-email')) return 'Email noto‘g‘ri';
    if (error.contains('weak-password')) return 'Parol juda oddiy';
    return 'Xatolik: $error';
  }

  Future<void> logout() async {
    final storage = ref.read(localStorageProvider);
    await storage.clearAll();
    await ref.read(authRepositoryProvider).logout();
  }

}
