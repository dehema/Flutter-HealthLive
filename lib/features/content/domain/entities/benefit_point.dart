import 'package:equatable/equatable.dart';

/// 单条「核心好处」要点，对应 `content_benefit_points` 表中的一行。
///
/// 在内容详情页以卡片形式展示；[icon] 为可选的语义化图标键名。
class BenefitPoint extends Equatable {
  const BenefitPoint({
    required this.title,
    required this.description,
    this.icon,
  });

  /// 要点标题，如「改善睡眠质量」。
  final String title;

  /// 要点说明。
  final String description;

  /// 图标标识（如 `sleep`、`walk`），可为空。
  final String? icon;

  @override
  List<Object?> get props => [title, description, icon];
}
