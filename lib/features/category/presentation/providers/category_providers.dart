import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/shared/utils/category_style.dart';

/// 从 JSON / 服务端加载全部分类。
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final result = await ref.watch(contentRepositoryProvider).getCategories();
  return result.when(
    success: (data) => data,
    error: (failure) => throw failure as Object,
  );
});

/// 当前选中的分类 ID（默认 1 = 作息）。
final selectedCategoryIdProvider = StateProvider<int>((ref) => 1);

/// 当前选中的分类实体；分类列表未加载完成时为 `null`。
final selectedCategoryProvider = Provider<Category?>((ref) {
  final categoryId = ref.watch(selectedCategoryIdProvider);
  final categories = ref.watch(categoriesProvider).valueOrNull ?? const [];
  return CategoryStyle.findById(categoryId, categories);
});

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
    ref.listen(selectedCategoryIdProvider, (_, __) {
      refresh();
    });
    ref.listen(categoriesProvider, (previous, next) {
      if (next.hasValue) {
        refresh();
      }
    });
    return _loadFirstPage();
  }

  Future<List<BenefitContent>> _loadFirstPage() async {
    _page = 1;
    _hasMore = true;
    final category = ref.read(selectedCategoryProvider);
    if (category == null) {
      return [];
    }

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
    if (category == null) {
      _isLoadingMore = false;
      return;
    }

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
