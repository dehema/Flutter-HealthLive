import 'package:equatable/equatable.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_point.dart';

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

  final String id;
  final String title;
  final String summary;
  final String coverUrl;
  final ContentCategory category;
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
        category,
        tags,
        points,
        body,
        updatedAt,
      ];
}
