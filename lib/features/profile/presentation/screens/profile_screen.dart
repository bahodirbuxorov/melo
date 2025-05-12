// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:melo/features/auth/presentation/providers/auth_user_provider.dart';
import '../../../../core/routing/route_names.dart';
import '../../../auth/presentation/providers/auth_provider.dart'; // logout uchun (ixtiyoriy)
import '../widgets/profile_app_bar.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_actions.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authUserProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),

      error: (err, _) => Scaffold(
        body: Center(child: Text('Xatolik: $err')),
      ),

      data: (user) {
        // 🔁 Stream yangilandi, lekin foydalanuvchi topilmadi — login sahifasiga
        if (user == null) {
          // Logout qilishni ham istasangiz:
          // ref.read(authControllerProvider.notifier).logout();

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.canPop()) {
              context.pop(); // stackda ortga qaytish
            }
            context.go(RouteNames.login);
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // ✔️ Foydalanuvchi bor
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
    );
  }
}
