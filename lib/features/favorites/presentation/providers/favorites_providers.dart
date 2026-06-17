import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

final favoritesListProvider =
    AsyncNotifierProvider<FavoritesListNotifier, List<BenefitContent>>(
  FavoritesListNotifier.new,
);

final favoriteStatusProvider =
    AsyncNotifierProviderFamily<FavoriteStatusNotifier, bool, String>(
  FavoriteStatusNotifier.new,
);

class FavoritesListNotifier extends AsyncNotifier<List<BenefitContent>> {
  @override
  Future<List<BenefitContent>> build() => _load();

  Future<List<BenefitContent>> _load() async {
    final repository = ref.read(favoritesRepositoryProvider);
    final result = await repository.getFavoriteContents();
    return result.when(
      success: (data) => data,
      error: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> remove(String contentId) async {
    final repository = ref.read(favoritesRepositoryProvider);
    await repository.removeFavorite(contentId);
    ref.invalidate(favoriteStatusProvider(contentId));
    await refresh();
  }
}

class FavoriteStatusNotifier extends FamilyAsyncNotifier<bool, String> {
  @override
  Future<bool> build(String arg) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final result = await repository.isFavorite(arg);
    return result.when(
      success: (data) => data,
      error: (failure) => throw failure,
    );
  }

  Future<void> toggle() async {
    final repository = ref.read(favoritesRepositoryProvider);
    final current = state.value ?? false;

    state = AsyncData(!current);

    final result = current
        ? await repository.removeFavorite(arg)
        : await repository.addFavorite(arg);

    if (result is Error<void>) {
      state = AsyncData(current);
      throw result.failure;
    }

    ref.invalidate(favoritesListProvider);
  }
}
