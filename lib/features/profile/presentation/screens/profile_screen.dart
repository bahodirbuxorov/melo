// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo/features/auth/presentation/providers/auth_user_provider.dart';
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_actions.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Foydalanuvchi topilmadi'));
        }

        return const SafeArea(
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: ProfileAppBar(),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(height: 32),
                  ProfileHeader(),
                  SizedBox(height: 40),
                  ProfileActions(),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Xatolik: $err')),
    );
  }
}
