import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/snackbar.dart';
import '../providers/auth_provider.dart';


class RegisterSubmitButton extends ConsumerWidget {
  const RegisterSubmitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);

    if (auth.isLoading) return const LoadingIndicator();

    final isEnabled = auth.email.isNotEmpty && auth.password.length >= 6;

    return ReusableButton(
      label: AppStrings.registerBtn,
      isEnabled: isEnabled,
      onPressed: () async {
        await authNotifier.register();

        if (context.mounted) {
          if (auth.errorMessage != null) {
            TopSnackbar.show(
              context,
              message: auth.errorMessage!,
              type: SnackbarType.error,
            );
          } else {
            TopSnackbar.show(
              context,
              message: 'Ro‘yxatdan muvaffaqiyatli o‘tildi!',
              type: SnackbarType.success,
            );
          }
        }
      },
    );
  }
}
