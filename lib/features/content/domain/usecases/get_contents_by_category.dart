import 'package:healthlive/core/constants/api_constants.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';

class GetContentsByCategory {
  const GetContentsByCategory(this._repository);

  final ContentRepository _repository;

  Future<Result<PaginatedContents>> call({
    required Category category,
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
  }) {
    return _repository.getContentsByCategory(
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}
