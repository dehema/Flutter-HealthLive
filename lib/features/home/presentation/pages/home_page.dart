import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthlive/app/router/routes.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/features/category/presentation/providers/category_providers.dart';
import 'package:healthlive/features/home/presentation/providers/home_providers.dart';
import 'package:healthlive/shared/utils/category_style.dart';
import 'package:healthlive/shared/widgets/async_value_widget.dart';
import 'package:healthlive/shared/widgets/content_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HealthLive'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.search),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(homeDataProvider.notifier).refresh(),
        child: AsyncValueWidget(
          value: homeAsync,
          onRetry: () => ref.invalidate(homeDataProvider),
          data: (homeData) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _DailyTipCard(
                title: homeData.dailyTip.title,
                summary: homeData.dailyTip.summary,
                onTap: () => context.push(
                  AppRoutes.contentDetailPath(homeData.dailyTip.contentId),
                ),
              ),
              const SizedBox(height: 20),
              Text('探索分类', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              const _CategoryShortcuts(),
              const SizedBox(height: 20),
              Text('为你推荐', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...homeData.recommended.map(
                (content) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ContentCard(
                    content: content,
                    onTap: () => context.push(
                      AppRoutes.contentDetailPath(content.id),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DailyTipCard extends StatelessWidget {
  const _DailyTipCard({
    required this.title,
    required this.summary,
    required this.onTap,
  });

  final String title;
  final String summary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primary.withValues(alpha: 0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.wb_sunny_outlined, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    '每日一知',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 6),
              Text(summary, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryShortcuts extends ConsumerWidget {
  const _CategoryShortcuts();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      loading: () => const SizedBox(
        height: 88,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (categories) => Row(
        children: categories.map((category) {
          final color = CategoryStyle.colorOf(category);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                child: InkWell(
                  onTap: () {
                    ref.read(selectedCategoryIdProvider.notifier).state =
                        category.id;
                    context.go(AppRoutes.category);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Icon(CategoryStyle.iconOf(category), color: color),
                        const SizedBox(height: 8),
                        Text(
                          category.name,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
