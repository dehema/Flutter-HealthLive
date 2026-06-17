import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/core/errors/failure.dart';
import 'package:healthlive/core/utils/exception_mapper.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/data/datasources/content_mock_datasource.dart';
import 'package:healthlive/features/content/data/datasources/content_remote_datasource.dart';
import 'package:healthlive/features/content/data/mappers/content_mapper.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl({
    required AppConfig config,
    required ContentRemoteDataSource remoteDataSource,
    required ContentMockDataSource mockDataSource,
  })  : _config = config,
        _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource;

  final AppConfig _config;
  final ContentRemoteDataSource _remoteDataSource;
  final ContentMockDataSource _mockDataSource;

  @override
  Future<Result<BenefitContent>> getContentDetail(String id) async {
    try {
      if (_config.useMockData) {
        final dto = await _mockDataSource.fetchById(id);
        if (dto == null) {
          return const Error(NotFoundFailure('内容不存在或已下线'));
        }
        return Success(ContentMapper.toEntity(dto));
      }

      final dto = await _remoteDataSource.fetchById(id);
      return Success(ContentMapper.toEntity(dto));
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<PaginatedContents>> getContentsByCategory({
    required ContentCategory category,
    required int page,
    required int pageSize,
  }) async {
    try {
      final dto = _config.useMockData
          ? await _mockDataSource.fetchByCategory(
              category: category,
              page: page,
              pageSize: pageSize,
            )
          : await _remoteDataSource.fetchByCategory(
              category: category,
              page: page,
              pageSize: pageSize,
            );
      return Success(ContentMapper.toPaginatedEntity(dto));
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<PaginatedContents>> searchContents({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    try {
      final dto = _config.useMockData
          ? await _mockDataSource.search(
              keyword: keyword,
              page: page,
              pageSize: pageSize,
            )
          : await _remoteDataSource.search(
              keyword: keyword,
              page: page,
              pageSize: pageSize,
            );
      return Success(ContentMapper.toPaginatedEntity(dto));
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<List<BenefitContent>>> getContentsByIds(
    List<String> ids,
  ) async {
    try {
      final all = _mockDataSource.getAll();
      final items = all
          .where((item) => ids.contains(item.id))
          .map(ContentMapper.toEntity)
          .toList();

      if (_config.useMockData) {
        return Success(items);
      }

      final results = <BenefitContent>[];
      for (final id in ids) {
        final detail = await getContentDetail(id);
        if (detail is Success<BenefitContent>) {
          results.add(detail.data);
        }
      }
      return Success(results);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }
}
