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
    final auth = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);

    if (auth.isLoading) return const ReusableShimmerTile();

    final isEnabled = auth.email.isNotEmpty && auth.password.length >= 6;

    return ReusableButton(
      label: 'Sign In',
      isEnabled: isEnabled,
      onPressed: () async {
        await authNotifier.login();

        if (context.mounted) {
          if (auth.errorMessage != null) {
            TopSnackbar.show(
              context,
              message: auth.errorMessage!,
              type: SnackbarType.error,
            );
          } else {
            context.go(RouteNames.home);
          }
        }
      },
    );
  }
}
