import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/features/category/presentation/providers/category_providers.dart';
import 'package:healthlive/features/content/presentation/providers/content_providers.dart';
import 'package:healthlive/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:healthlive/shared/utils/category_style.dart';
import 'package:healthlive/shared/widgets/async_value_widget.dart';
import 'package:healthlive/shared/widgets/tag_chip.dart';
import 'package:intl/intl.dart';

class ContentDetailPage extends ConsumerWidget {
  const ContentDetailPage({super.key, required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(contentDetailProvider(contentId));
    final favoriteAsync = ref.watch(favoriteStatusProvider(contentId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('内容详情'),
        actions: [
          favoriteAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, __) => const SizedBox.shrink(),
            data: (isFavorite) => IconButton(
              onPressed: () async {
                try {
                  await ref
                      .read(favoriteStatusProvider(contentId).notifier)
                      .toggle();
                } catch (error) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(error.toString())),
                    );
                  }
                }
              },
              icon: Icon(
                isFavorite ? Icons.bookmark : Icons.bookmark_outline,
              ),
            ),
          ),
        ],
      ),
      body: AsyncValueWidget(
        value: detailAsync,
        onRetry: () => ref.invalidate(contentDetailProvider(contentId)),
        data: (content) {
          final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
          final category = CategoryStyle.findById(content.categoryId, categories);
          final categoryColor = category != null
              ? CategoryStyle.colorOf(category)
              : AppColors.primary;
          final categoryIcon = category != null
              ? CategoryStyle.iconOf(category)
              : Icons.category_outlined;
          final categoryName = category?.name ?? '';

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              if (content.coverUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CachedNetworkImage(
                      imageUrl: content.coverUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    categoryIcon,
                    size: 56,
                    color: categoryColor,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                content.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                '${categoryName.isEmpty ? '未分类' : categoryName} · ${DateFormat('yyyy-MM-dd').format(content.updatedAt)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: content.tags.map((tag) => TagChip(label: tag)).toList(),
              ),
              const SizedBox(height: 20),
              Text('核心好处', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...content.points.map(
                (point) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor:
                              categoryColor.withValues(alpha: 0.15),
                          child: Icon(
                            Icons.check,
                            size: 18,
                            color: categoryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                point.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                point.description,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text('详细说明', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              MarkdownBody(
                data: content.body,
                styleSheet: MarkdownStyleSheet(
                  p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
