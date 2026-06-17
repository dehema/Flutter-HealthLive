import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/shared/utils/category_style.dart';
import 'package:healthlive/shared/widgets/tag_chip.dart';
import 'package:intl/intl.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.content,
    this.onTap,
  });

  final BenefitContent content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryStyle.colorOf(content.category);
    final dateText = DateFormat('yyyy-MM-dd').format(content.updatedAt);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Cover(
              coverUrl: content.coverUrl,
              categoryColor: categoryColor,
              category: content.category,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content.summary,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: content.tags
                          .take(3)
                          .map((tag) => TagChip(label: tag))
                          .toList(),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({
    required this.coverUrl,
    required this.categoryColor,
    required this.category,
  });

  final String coverUrl;
  final Color categoryColor;
  final ContentCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108,
      height: 108,
      child: coverUrl.isEmpty
          ? ColoredBox(
              color: categoryColor.withValues(alpha: 0.15),
              child: Icon(
                CategoryStyle.iconOf(category),
                color: categoryColor,
                size: 36,
              ),
            )
          : CachedNetworkImage(
              imageUrl: coverUrl,
              fit: BoxFit.cover,
              errorWidget: (_, __, ___) => ColoredBox(
                color: categoryColor.withValues(alpha: 0.15),
                child: Icon(
                  CategoryStyle.iconOf(category),
                  color: categoryColor,
                ),
              ),
            ),
    );
  }
}
