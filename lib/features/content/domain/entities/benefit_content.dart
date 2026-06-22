import 'package:equatable/equatable.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_point.dart';

/// 健康科普内容实体，对应服务端 `contents` 表及 JSON 种子数据。
///
/// 列表场景通常只用到 [id]、[title]、[summary]、[coverUrl]、[category]、[tags]、
/// [updatedAt]；详情页会额外读取 [points] 与 [body]。
class BenefitContent extends Equatable {
  const BenefitContent({
    required this.id,
    required this.title,
    required this.summary,
    required this.coverUrl,
    required this.category,
    required this.tags,
    required this.points,
    required this.body,
    required this.updatedAt,
  });

  /// 内容唯一标识（JSON 模式下为数字字符串，如 `"1"`）。
  final String id;

  /// 标题。
  final String title;

  /// 列表/卡片摘要。
  final String summary;

  /// 封面图 URL，为空时 UI 使用分类占位图。
  final String coverUrl;

  /// 所属分类：生活方式 / 运动 / 饮食。
  final ContentCategory category;

  /// 标签列表，来自 `content_tags` 关联。
  final List<String> tags;

  /// 核心好处要点，来自 `content_benefit_points` 关联。
  final List<BenefitPoint> points;

  /// Markdown 正文。
  final String body;

  /// 最近更新时间，用于列表排序与展示。
  final DateTime updatedAt;

  @override
  List<Object?> get props => [
        id,
        title,
        summary,
        coverUrl,
        category,
        tags,
        points,
        body,
        updatedAt,
      ];
}
