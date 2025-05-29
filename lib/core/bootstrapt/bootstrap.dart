/// Barcha async tayyorgarlik ishlarini bajarib,
/// ProviderScope.overrides ro‘yxatini qaytaradi.
library;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifications/notification_service.dart';
import '../routing/initial_route_provider.dart';
import 'firebase_setup.dart';

final savedThemeModeProvider = Provider<ThemeMode>((ref) => throw UnimplementedError());

Future<List<Override>> bootstrap() async {
  await initFirebase();
  await setupFlutterNotifications();

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;
  final isDark = prefs.getBool('is_dark_mode') ?? true;
  final initialRoute = rememberMe ? '/home' : '/login';

  return [
    initialRouteProvider.overrideWithValue(initialRoute),
    savedThemeModeProvider.overrideWithValue(isDark ? ThemeMode.dark : ThemeMode.light),
  ];
}
