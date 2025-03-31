// core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:melo/core/routing/root_nav_screen.dart';
import 'package:melo/features/auth/presentation/screens/register_screen.dart';
import 'package:melo/features/auth/presentation/screens/login_screen.dart';
import '../../features/chat/domain/entities/chat_entity.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/chat/presentation/screens/new_chat_screen.dart';
import 'route_names.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteNames.home, // RootNav
      builder: (context, state) => const RootNavScreen(),
    ),
    GoRoute(
      path: RouteNames.newChat,
      builder: (context, state) => const NewChatScreen(),
    ),
    GoRoute(
      path: ChatDetailScreen.routeName,
      builder: (context, state) {
        final chat = state.extra as ChatEntity;
        return ChatDetailScreen(chat: chat);
      },
    ),


  ],
);
