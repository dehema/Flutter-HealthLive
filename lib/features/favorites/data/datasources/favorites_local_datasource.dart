import 'package:healthlive/core/storage/hive_boxes.dart';
import 'package:healthlive/core/storage/local_storage.dart';

class FavoritesLocalDataSource {
  FavoritesLocalDataSource({required LocalStorage localStorage})
      : _localStorage = localStorage;

  final LocalStorage _localStorage;

  List<String> readFavoriteIds() {
    final raw = _localStorage.favoritesBox.get(HiveKeys.favoriteIds);
    if (raw is List<dynamic>) {
      return raw.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  Future<void> writeFavoriteIds(List<String> ids) async {
    await _localStorage.favoritesBox.put(HiveKeys.favoriteIds, ids);
  }
}
