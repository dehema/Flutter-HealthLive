import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

final selectedCategoryProvider = StateProvider<ContentCategory>(
  (ref) => ContentCategory.lifestyle,
);

final categoryListProvider =
    AsyncNotifierProvider<CategoryListNotifier, List<BenefitContent>>(
  CategoryListNotifier.new,
);

class CategoryListNotifier extends AsyncNotifier<List<BenefitContent>> {
  int _page = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  @override
  Future<List<BenefitContent>> build() async {
    ref.listen(selectedCategoryProvider, (_, __) {
      refresh();
    });
    return _loadFirstPage();
  }

  Future<List<BenefitContent>> _loadFirstPage() async {
    _page = 1;
    _hasMore = true;
    final category = ref.read(selectedCategoryProvider);
    final useCase = ref.read(getContentsByCategoryProvider);
    final result = await useCase(category: category, page: _page);

    return result.when(
      success: (data) {
        _hasMore = data.hasMore;
        return data.items;
      },
      error: (failure) => throw failure as Object,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFirstPage);
  }

  bool get hasMore => _hasMore;

  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadMore() async {
    if (!_hasMore || _isLoadingMore || !state.hasValue) {
      return;
    }

    _isLoadingMore = true;
    final current = state.requireValue;
    _page += 1;

    final category = ref.read(selectedCategoryProvider);
    final useCase = ref.read(getContentsByCategoryProvider);
    final result = await useCase(category: category, page: _page);

    result.when(
      success: (data) {
        _hasMore = data.hasMore;
        state = AsyncData([...current, ...data.items]);
      },
      error: (failure) {
        _page -= 1;
        state = AsyncError(failure as Object, StackTrace.current);
      },
    );

    _isLoadingMore = false;
  }
}
