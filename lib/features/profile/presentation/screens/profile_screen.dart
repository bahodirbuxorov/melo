
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:melo/features/auth/presentation/providers/auth_user_provider.dart';
import '../../../../core/routing/route_names.dart';
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

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.canPop()) {
              context.pop();
            }
            context.go(RouteNames.login);
          });

          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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
    );
  }
}
