import 'package:healthlive/features/content/data/models/benefit_point_dto.dart';
import 'package:healthlive/features/content/data/models/content_dto.dart';
import 'package:healthlive/features/content/data/models/paginated_response_dto.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/content/domain/entities/benefit_point.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';

class ContentMapper {
  const ContentMapper._();

  static BenefitContent toEntity(ContentDto dto) {
    return BenefitContent(
      id: dto.id,
      title: dto.title,
      summary: dto.summary,
      coverUrl: dto.coverUrl,
      categoryId: dto.categoryId,
      tags: dto.tags,
      points: dto.points.map(_toPointEntity).toList(),
      body: dto.body,
      updatedAt: DateTime.tryParse(dto.updatedAt) ?? DateTime.now(),
    );
  }

  static BenefitPoint _toPointEntity(BenefitPointDto dto) {
    return BenefitPoint(
      title: dto.title,
      description: dto.description,
      icon: dto.icon,
    );
  }

  static PaginatedContents toPaginatedEntity(PaginatedResponseDto dto) {
    return PaginatedContents(
      items: dto.items.map(toEntity).toList(),
      total: dto.total,
      page: dto.page,
      pageSize: dto.pageSize,
    );
  }
}
