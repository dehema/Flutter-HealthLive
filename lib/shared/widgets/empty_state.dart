import 'package:flutter/material.dart';

/// 数据为空时的居中占位提示，支持标题、副标题与自定义操作区。
///
/// 通常由 [AsyncValueWidget] 在 [isEmpty] 为真时展示，
/// 也可在各页面单独使用（如分类无结果、收藏为空）。
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  /// 主提示文案。
  final String title;

  /// 可选的补充说明。
  final String? subtitle;

  /// 可选操作按钮等自定义 Widget。
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 56,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
