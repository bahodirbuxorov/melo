import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/theme_provider.dart';
import '../core/routing/app_router.dart';
import '../core/routing/initial_route_provider.dart';
import 'core/services/user_presence_service.dart';
import 'core/theme/app_theme.dart';

class MeloApp extends ConsumerWidget {
  const MeloApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(userPresenceServiceProvider);

    final themeMode = ref.watch(themeModeProvider);
    final initial = ref.watch(initialRouteProvider);
    final router = createRouter(initialLocation: initial);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Melo',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
