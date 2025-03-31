import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../auth/presentation/providers/auth_user_provider.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';


final userRepositoryProvider = Provider<UserRepository>((ref) {
  return FirebaseUserRepository(firestore: FirebaseFirestore.instance);
});

final userListProvider = StreamProvider<List<UserEntity>>((ref) {
  final currentUser = ref.watch(authUserProvider).value;
  final repository = ref.watch(userRepositoryProvider);

  if (currentUser == null) return const Stream.empty();
  return repository.getAllUsers(currentUser.uid);
});
