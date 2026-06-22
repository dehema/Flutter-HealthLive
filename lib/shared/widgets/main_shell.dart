import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';

/// 主导航壳层：底部 [NavigationBar] + 子路由 [child] 内容区。
///
/// 包裹首页、分类、收藏、我的四个 Tab 页面，
/// 根据当前路由高亮对应 Tab 并处理切换。
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  /// 当前 Tab 对应的子页面（由 GoRouter 注入）。
  final Widget child;

  /// 将路由路径映射为底部导航索引。
  int _locationToIndex(String location) {
    if (location.startsWith(AppRoutes.category)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.favorites)) {
      return 2;
    }
    if (location.startsWith(AppRoutes.profile)) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.category);
            case 2:
              context.go(AppRoutes.favorites);
            case 3:
              context.go(AppRoutes.profile);
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: '发现',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category),
            label: '分类',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: '收藏',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}
