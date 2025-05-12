/// Barcha async tayyorgarlik ishlarini bajarib,
/// ProviderScope.overrides ro‘yxatini qaytaradi.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifications/notification_service.dart';
import '../routing/initial_route_provider.dart';
import 'firebase_setup.dart';


Future<List<Override>> bootstrap() async {
  await initFirebase();                 // Firebase & FCM
  await setupFlutterNotifications();    // Local notifications

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;
  final initialRoute = rememberMe ? '/home' : '/login';

  return [
    initialRouteProvider.overrideWithValue(initialRoute),
  ];
}
