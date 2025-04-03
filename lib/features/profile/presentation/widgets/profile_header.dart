// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:melo/core/theme/colors.dart';
import '../../../auth/presentation/providers/auth_user_provider.dart';

class ProfileHeader extends ConsumerWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider).value;

    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(IconlyLight.profile, size: 40, color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          user?.email ?? 'No email',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }
}