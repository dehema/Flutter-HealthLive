import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

abstract class FavoritesRepository {
  Future<Result<List<String>>> getFavoriteIds();

  Future<Result<List<BenefitContent>>> getFavoriteContents();

  Future<Result<void>> addFavorite(String contentId);

  Future<Result<void>> removeFavorite(String contentId);

  Future<Result<bool>> isFavorite(String contentId);
}
