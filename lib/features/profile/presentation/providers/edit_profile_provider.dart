import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final editProfileControllerProvider =
StateNotifierProvider<EditProfileController, AsyncValue<void>>((ref) {
  final repo = ref.read(authRepositoryProvider);
  final user = ref.watch(authUserProvider).value;
  return EditProfileController(authRepository: repo, userName: user?.name ?? '', userBio: user?.bio ?? '');
});

class EditProfileController extends StateNotifier<AsyncValue<void>> {
  final AuthRepository authRepository;
  final String userName;
  final String userBio;

  EditProfileController({
    required this.authRepository,
    required this.userName,
    required this.userBio,
  }) : super(const AsyncData(null));

  Future<void> update(String name, String bio) async {
    state = const AsyncLoading();
    try {
      await authRepository.updateUserProfile(name: name, bio: bio);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
