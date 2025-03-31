import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';

class AuthToggleButton extends StatelessWidget {
  final bool isLogin;

  const AuthToggleButton({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          context.go(isLogin ? RouteNames.register : RouteNames.login);
        },
        child: Text(
          isLogin
              ? "Don't have an account? Register"
              : "Already have an account? Login",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}