import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/app/app.dart';
import 'package:healthlive/core/di/providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  await container.read(localStorageProvider).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: HealthLiveApp(),
    ),
  );
}
