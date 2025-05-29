import 'package:go_router/go_router.dart';
import 'package:melo/core/routing/root_nav_screen.dart';
import 'package:melo/features/auth/presentation/screens/register_screen.dart';
import 'package:melo/features/auth/presentation/screens/login_screen.dart';
import 'package:melo/features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/chat/domain/entities/chat_entity.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/new_chat_screen.dart';
import 'route_names.dart';

GoRouter createRouter({required String initialLocation}) {
  return GoRouter(
    initialLocation: initialLocation,
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
        path: RouteNames.home,
        builder: (context, state) => const RootNavScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
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

      GoRoute(
        path: '/chat-detail/:id',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return ChatDetailScreen(chatId: chatId); // Push notification deep link
        },
      ),
    ],
  );
}
