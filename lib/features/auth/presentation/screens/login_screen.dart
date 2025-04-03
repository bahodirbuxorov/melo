// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo/features/auth/presentation/providers/auth_provider.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_gradients.dart';
import '../widgets/login_header.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/login_submit_button.dart';
import '../widgets/auth_toggle_button.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _ = ref.watch(authControllerProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.main),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.p24, vertical: Sizes.p16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: Sizes.p32),

                  // Card-style form
                  Container(
                    padding: const EdgeInsets.all(Sizes.p24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.borderRadiusLg),
                      color: Theme.of(context).cardColor.withOpacity(0.85),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        AuthTextField(
                          hint: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: Sizes.p16),
                        AuthTextField(
                          hint: 'Enter your password',
                          isPassword: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: Sizes.p32),
                  const LoginSubmitButton(),
                  const SizedBox(height: Sizes.p12),
                  const AuthToggleButton(isLogin: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
