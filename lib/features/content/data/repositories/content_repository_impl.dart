import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/errors/failure.dart';
import 'package:healthlive/core/utils/exception_mapper.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/category/data/mappers/category_mapper.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';
import 'package:healthlive/features/content/data/datasources/content_json_datasource.dart';
import 'package:healthlive/features/content/data/datasources/content_remote_datasource.dart';
import 'package:healthlive/features/content/data/mappers/content_mapper.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/content/domain/entities/paginated_contents.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';

class ContentRepositoryImpl implements ContentRepository {
  ContentRepositoryImpl({
    required AppConfig config,
    required ContentRemoteDataSource remoteDataSource,
    required ContentJsonDataSource jsonDataSource,
  })  : _config = config,
        _remoteDataSource = remoteDataSource,
        _jsonDataSource = jsonDataSource;

  final AppConfig _config;
  final ContentRemoteDataSource _remoteDataSource;
  final ContentJsonDataSource _jsonDataSource;

  static const _fallbackCategories = [
    Category(id: 1, code: 'lifestyle', name: '作息', icon: 'bedtime_outlined', color: '#5B8DEF', sortOrder: 1),
    Category(id: 2, code: 'exercise', name: '运动', icon: 'directions_run_outlined', color: '#3D8B7A', sortOrder: 2),
    Category(id: 3, code: 'diet', name: '饮食', icon: 'restaurant_outlined', color: '#F2A65A', sortOrder: 3),
  ];

  @override
  Future<Result<List<Category>>> getCategories() async {
    try {
      if (_config.usesJsonContent) {
        final dtos = await _jsonDataSource.fetchCategories();
        return Success(dtos.map(CategoryMapper.toEntity).toList());
      }
      return const Success(_fallbackCategories);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<BenefitContent>> getContentDetail(String id) async {
    try {
      if (_config.usesJsonContent) {
        final dto = await _jsonDataSource.fetchById(id);
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
    required Category category,
    required int page,
    required int pageSize,
  }) async {
    try {
      final dto = _config.usesJsonContent
          ? await _jsonDataSource.fetchByCategory(
              categoryId: category.id,
              page: page,
              pageSize: pageSize,
            )
          : await _remoteDataSource.fetchByCategory(
              categoryCode: category.code,
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
      final dto = _config.usesJsonContent
          ? await _jsonDataSource.search(
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
      if (_config.usesJsonContent) {
        final all = await _jsonDataSource.getAll();
        final items = all
            .where((item) => ids.contains(item.id))
            .map(ContentMapper.toEntity)
            .toList();
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
