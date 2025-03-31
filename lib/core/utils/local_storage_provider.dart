// lib/core/utils/local_storage_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'local_storage_service.dart';

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
