import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/bootstrapt/bootstrap.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final overrides = await bootstrap();

  runApp(
    ProviderScope(overrides: overrides, child: const MeloApp()),
  );
}
