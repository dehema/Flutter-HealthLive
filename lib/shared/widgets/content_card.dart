import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/shared/utils/category_style.dart';
import 'package:intl/intl.dart';

/// 内容列表通用卡片，用于分类浏览、首页推荐、收藏、搜索等场景。
class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.content,
    this.onTap,
  });

  /// 要展示的内容数据。
  final BenefitContent content;

  /// 点击卡片时的跳转或交互回调。
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final categoryColor = CategoryStyle.colorOf(content.category);
    final dateText = DateFormat('yyyy-MM-dd').format(content.updatedAt);
    final title = kDebugMode
        ? '[${content.id}] ${content.title}'
        : content.title;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _CoverImage(
                    coverUrl: content.coverUrl,
                    categoryColor: categoryColor,
                    category: content.category,
                  ),
                  Positioned(
                    left: 10,
                    top: 10,
                    child: _CategoryBadge(
                      label: content.category.displayName,
                      color: categoryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          height: 1.35,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    content.summary,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 13,
                          height: 1.45,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (content.tags.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: content.tags
                          .take(3)
                          .map(
                            (tag) => _TagChip(
                              label: tag,
                              color: categoryColor,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 14,
                        color: AppColors.textSecondary.withValues(alpha: 0.85),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        dateText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 封面左上角分类标签（白底 + 分类色圆点）。
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 卡片内标签胶囊，背景色随分类主题色变化。
class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: color.withValues(alpha: 0.95),
          height: 1.2,
        ),
      ),
    );
  }
}

/// 封面网络图，含加载占位与失败回退。
class _CoverImage extends StatelessWidget {
  const _CoverImage({
    required this.coverUrl,
    required this.categoryColor,
    required this.category,
  });

  final String coverUrl;
  final Color categoryColor;
  final ContentCategory category;

  @override
  Widget build(BuildContext context) {
    if (coverUrl.isEmpty) {
      return _CoverFallback(
        categoryColor: categoryColor,
        category: category,
      );
    }

    return CachedNetworkImage(
      imageUrl: coverUrl,
      fit: BoxFit.cover,
      placeholder: (_, __) => ColoredBox(
        color: categoryColor.withValues(alpha: 0.08),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: categoryColor.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => _CoverFallback(
        categoryColor: categoryColor,
        category: category,
      ),
    );
  }
}

/// 无封面或加载失败时的渐变 + 分类图标占位。
class _CoverFallback extends StatelessWidget {
  const _CoverFallback({
    required this.categoryColor,
    required this.category,
  });

  final Color categoryColor;
  final ContentCategory category;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            categoryColor.withValues(alpha: 0.18),
            categoryColor.withValues(alpha: 0.06),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          CategoryStyle.iconOf(category),
          color: categoryColor.withValues(alpha: 0.65),
          size: 40,
        ),
      ),
    );
  }
}
