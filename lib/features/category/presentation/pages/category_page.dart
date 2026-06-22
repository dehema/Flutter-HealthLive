import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';
import 'package:healthlive/features/category/presentation/providers/category_providers.dart';
import 'package:healthlive/shared/widgets/async_value_widget.dart';
import 'package:healthlive/shared/widgets/content_card.dart';
import 'package:healthlive/shared/widgets/empty_state.dart';

class CategoryPage extends ConsumerWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final listAsync = ref.watch(categoryListProvider);
    final notifier = ref.read(categoryListProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('分类浏览'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: AsyncValueWidget(
              value: categoriesAsync,
              onRetry: () => ref.invalidate(categoriesProvider),
              data: (categories) => SegmentedButton<int>(
                segments: categories
                    .map(
                      (category) => ButtonSegment(
                        value: category.id,
                        label: Text(category.name),
                      ),
                    )
                    .toList(),
                selected: {selectedCategoryId},
                onSelectionChanged: (selection) {
                  ref.read(selectedCategoryIdProvider.notifier).state =
                      selection.first;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: notifier.refresh,
              child: AsyncValueWidget(
                value: listAsync,
                onRetry: () => ref.invalidate(categoryListProvider),
                isEmpty: (items) => items.isEmpty,
                empty: const EmptyState(
                  title: '该分类暂无内容',
                  subtitle: '可以稍后再来看看',
                ),
                data: (items) => NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.pixels >=
                            notification.metrics.maxScrollExtent - 120 &&
                        !notifier.isLoadingMore) {
                      notifier.loadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length + (notifier.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index >= items.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      final content = items[index];
                      return ContentCard(
                        content: content,
                        onTap: () => context.push(
                          AppRoutes.contentDetailPath(content.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
