  // lib/features/auth/presentation/providers/auth_user_provider.dart
  import 'package:flutter_riverpod/flutter_riverpod.dart';
  import 'package:firebase_auth/firebase_auth.dart';

  /// Real-time auth user stream
  final authUserProvider = StreamProvider<User?>((ref) {
    return FirebaseAuth.instance.authStateChanges();
  });

