import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';
import 'package:healthlive/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:healthlive/shared/widgets/async_value_widget.dart';
import 'package:healthlive/shared/widgets/content_card.dart';
import 'package:healthlive/shared/widgets/empty_state.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: RefreshIndicator(
        onRefresh: () => ref.read(favoritesListProvider.notifier).refresh(),
        child: AsyncValueWidget(
          value: favoritesAsync,
          onRetry: () => ref.invalidate(favoritesListProvider),
          isEmpty: (items) => items.isEmpty,
          empty: EmptyState(
            title: '还没有收藏内容',
            subtitle: '在详情页点击书签即可收藏',
            action: FilledButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('去发现更多'),
            ),
          ),
          data: (items) => ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final content = items[index];
              return Dismissible(
                key: ValueKey(content.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  color: Theme.of(context).colorScheme.error,
                  child: const Icon(Icons.delete_outline, color: Colors.white),
                ),
                onDismissed: (_) {
                  ref.read(favoritesListProvider.notifier).remove(content.id);
                },
                child: ContentCard(
                  content: content,
                  onTap: () => context.push(
                    AppRoutes.contentDetailPath(content.id),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
