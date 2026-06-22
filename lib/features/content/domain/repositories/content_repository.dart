import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';

abstract class ContentRepository {
  Future<Result<List<Category>>> getCategories();

  Future<Result<BenefitContent>> getContentDetail(String id);

  Future<Result<PaginatedContents>> getContentsByCategory({
    required Category category,
    required int page,
    required int pageSize,
  });

  Future<Result<PaginatedContents>> searchContents({
    required String keyword,
    required int page,
    required int pageSize,
  });

  Future<Result<List<BenefitContent>>> getContentsByIds(List<String> ids);
}
