import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:melo/core/theme/theme_provider.dart';
import 'package:melo/features/auth/presentation/providers/auth_provider.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/custom_button.dart';

class ProfileActions extends ConsumerWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: const Icon(IconlyLight.edit),
            title: const Text("Edit Profile"),
            onTap: () {
              context.push(RouteNames.editProfile);
            },

          ),
          ListTile(
            leading: const Icon(IconlyLight.chart),
            title: const Text("Dark Mode"),
            trailing: Switch.adaptive(
              value: isDark,
              onChanged: (val) {
                final notifier = ref.read(themeModeProvider.notifier);
                notifier.setTheme(val ? ThemeMode.dark : ThemeMode.light);
              },
            ),

          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ReusableButton(
              label: 'Logout',
              onPressed: () async {
                await authController.logout();
                if (context.mounted) {
                  context.go('/login'); // GoRouter orqali navigatsiya
                }
                debugPrint("🚪 Logged out and navigated to login");
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
