import 'package:healthlive/core/utils/exception_mapper.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';
import 'package:healthlive/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:healthlive/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  FavoritesRepositoryImpl({
    required FavoritesLocalDataSource localDataSource,
    required ContentRepository contentRepository,
  })  : _localDataSource = localDataSource,
        _contentRepository = contentRepository;

  final FavoritesLocalDataSource _localDataSource;
  final ContentRepository _contentRepository;

  @override
  Future<Result<List<String>>> getFavoriteIds() async {
    try {
      return Success(_localDataSource.readFavoriteIds());
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<List<BenefitContent>>> getFavoriteContents() async {
    final idsResult = await getFavoriteIds();
    if (idsResult is Error<List<String>>) {
      return Error(idsResult.failure);
    }

    final ids = (idsResult as Success<List<String>>).data;
    if (ids.isEmpty) {
      return const Success([]);
    }

    final contentsResult = await _contentRepository.getContentsByIds(ids);
    if (contentsResult is Error<List<BenefitContent>>) {
      return Error(contentsResult.failure);
    }

    final contents = (contentsResult as Success<List<BenefitContent>>).data;
    final order = {for (var i = 0; i < ids.length; i++) ids[i]: i};
    contents.sort(
      (a, b) => (order[a.id] ?? 0).compareTo(order[b.id] ?? 0),
    );
    return Success(contents);
  }

  @override
  Future<Result<void>> addFavorite(String contentId) async {
    try {
      final ids = _localDataSource.readFavoriteIds();
      if (!ids.contains(contentId)) {
        ids.insert(0, contentId);
        await _localDataSource.writeFavoriteIds(ids);
      }
      return const Success(null);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<void>> removeFavorite(String contentId) async {
    try {
      final ids = _localDataSource.readFavoriteIds()..remove(contentId);
      await _localDataSource.writeFavoriteIds(ids);
      return const Success(null);
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }

  @override
  Future<Result<bool>> isFavorite(String contentId) async {
    final ids = _localDataSource.readFavoriteIds();
    return Success(ids.contains(contentId));
  }
}
