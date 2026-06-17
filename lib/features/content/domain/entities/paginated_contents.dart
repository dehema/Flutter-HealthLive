import 'package:equatable/equatable.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

class PaginatedContents extends Equatable {
  const PaginatedContents({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<BenefitContent> items;
  final int total;
  final int page;
  final int pageSize;

  bool get hasMore => page * pageSize < total;

  @override
  List<Object?> get props => [items, total, page, pageSize];
}
