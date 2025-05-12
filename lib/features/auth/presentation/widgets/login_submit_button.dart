import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../core/widgets/snackbar.dart';
import '../providers/auth_provider.dart';

class LoginSubmitButton extends ConsumerWidget {
  const LoginSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    final notifier = ref.read(authControllerProvider.notifier);

    if (state.isLoading) return const ReusableShimmerTile();

    final enabled = state.email.isNotEmpty && state.password.length >= 6;

    return ReusableButton(
      label: 'Sign In',
      isEnabled: enabled,
      onPressed: enabled
          ? () async {
        await notifier.login();

        if (!context.mounted) return;

        final newState = ref.read(authControllerProvider);

        if (newState.errorMessage != null) {

          TopSnackbar.show(
            context,
            message: newState.errorMessage!,
            type: SnackbarType.error,
          );
        } else {

          context.go(RouteNames.home);
        }
      }
          : null,
    );
  }
}

