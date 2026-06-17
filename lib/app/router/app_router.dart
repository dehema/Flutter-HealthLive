import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';
import 'package:healthlive/features/category/presentation/pages/category_page.dart';
import 'package:healthlive/features/content/presentation/pages/content_detail_page.dart';
import 'package:healthlive/features/favorites/presentation/pages/favorites_page.dart';
import 'package:healthlive/features/home/presentation/pages/home_page.dart';
import 'package:healthlive/features/profile/presentation/pages/profile_page.dart';
import 'package:healthlive/features/search/presentation/pages/search_page.dart';
import 'package:healthlive/shared/widgets/main_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.category,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CategoryPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.favorites,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FavoritesPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: AppRoutes.contentDetail,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ContentDetailPage(contentId: id);
        },
      ),
    ],
  );
}
