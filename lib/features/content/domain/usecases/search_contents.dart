import 'package:healthlive/core/constants/api_constants.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';

class SearchContents {
  const SearchContents(this._repository);

  final ContentRepository _repository;

  Future<Result<PaginatedContents>> call({
    required String keyword,
    int page = 1,
    int pageSize = ApiConstants.defaultPageSize,
  }) {
    return _repository.searchContents(
      keyword: keyword,
      page: page,
      pageSize: pageSize,
    );
  }
}
