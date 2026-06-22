import 'package:equatable/equatable.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

/// 分页内容列表的域模型，封装一页 [BenefitContent] 及分页元数据。
///
/// 分类浏览、搜索等接口返回此结构；[hasMore] 用于判断是否继续加载下一页。
class PaginatedContents extends Equatable {
  const PaginatedContents({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  /// 当前页内容列表。
  final List<BenefitContent> items;

  /// 符合条件的总条数。
  final int total;

  /// 当前页码，从 1 开始。
  final int page;

  /// 每页条数。
  final int pageSize;

  /// 是否还有未加载的下一页。
  bool get hasMore => page * pageSize < total;

  @override
  List<Object?> get props => [items, total, page, pageSize];
}
