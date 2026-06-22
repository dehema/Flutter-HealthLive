import 'package:equatable/equatable.dart';
import 'package:healthlive/features/content/domain/entities/benefit_point.dart';

/// 健康科普内容实体，对应服务端 `contents` 表及 JSON 种子数据。
///
/// 列表场景通常只用到 [id]、[title]、[summary]、[coverUrl]、[categoryId]、[tags]、
/// [updatedAt]；详情页会额外读取 [points] 与 [body]。
class BenefitContent extends Equatable {
  const BenefitContent({
    required this.id,
    required this.title,
    required this.summary,
    required this.coverUrl,
    required this.categoryId,
    required this.tags,
    required this.points,
    required this.body,
    required this.updatedAt,
  });

  /// 内容唯一标识，格式为 `category_id * 1000 + 序号`（如 `1011`）。
  final String id;

  final String title;
  final String summary;
  final String coverUrl;

  /// 关联 `categories.id`。
  final int categoryId;

  final List<String> tags;
  final List<BenefitPoint> points;
  final String body;
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        coverUrl,
        categoryId,
        tags,
        points,
        body,
        updatedAt,
      ];
}
