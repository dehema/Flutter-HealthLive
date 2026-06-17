import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/app_router.dart';
import 'package:healthlive/app/theme/app_theme.dart';

class HealthLiveApp extends ConsumerWidget {
  HealthLiveApp({super.key});

  final GoRouter _router = createAppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'HealthLive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}
