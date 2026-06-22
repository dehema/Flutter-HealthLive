import 'package:flutter/material.dart';

/// 通用标签胶囊，基于 Material [Chip] 的紧凑样式。
///
/// 用于内容详情页等需要展示标签的场景；
/// 列表卡片 [ContentCard] 使用内联的 `_TagChip` 以匹配分类配色。
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  /// 标签文案。
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
