import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:melo/features/auth/presentation/providers/auth_provider.dart';

import '../../../../core/widgets/custom_button.dart';


class ProfileActions extends ConsumerWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authControllerProvider.notifier);

    return Expanded(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit_outlined),
            title: const Text("Edit Profile"),
            onTap: () {
              // TODO: Navigate to edit page
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text("Dark Mode"),
            trailing: Switch.adaptive(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (val) {
                // TODO: handle theme toggle
              },
            ),
          ),
          const Spacer(),
          ReusableButton(
            label: 'Logout',
            onPressed: () async {
              await authController.logout();
              // TODO: Navigate back to login screen
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
