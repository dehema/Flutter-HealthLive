import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/constants/api_constants.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

final searchKeywordProvider = StateProvider<String>((ref) => '');

final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(
  SearchHistoryNotifier.new,
);

class SearchHistoryNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final dataSource = ref.read(searchHistoryLocalDataSourceProvider);
    return dataSource.readHistory();
  }

  Future<void> addKeyword(String keyword) async {
    final dataSource = ref.read(searchHistoryLocalDataSourceProvider);
    await dataSource.addKeyword(keyword);
    state = dataSource.readHistory();
  }

  Future<void> clear() async {
    final dataSource = ref.read(searchHistoryLocalDataSourceProvider);
    await dataSource.clearHistory();
    state = [];
  }
}

final searchResultProvider =
    AsyncNotifierProvider<SearchResultNotifier, List<BenefitContent>>(
  SearchResultNotifier.new,
);

class SearchResultNotifier extends AsyncNotifier<List<BenefitContent>> {
  Timer? _debounce;

  @override
  Future<List<BenefitContent>> build() async => [];

  void search(String keyword) {
    _debounce?.cancel();
    _debounce = Timer(ApiConstants.searchDebounce, () async {
      final normalized = keyword.trim();
      ref.read(searchKeywordProvider.notifier).state = normalized;

      if (normalized.isEmpty) {
        state = const AsyncData([]);
        return;
      }

      state = const AsyncLoading();
      state = await AsyncValue.guard(() => _query(normalized));
      await ref.read(searchHistoryProvider.notifier).addKeyword(normalized);
    });
  }

  Future<List<BenefitContent>> _query(String keyword) async {
    final useCase = ref.read(searchContentsProvider);
    final result = await useCase(keyword: keyword);
    return result.when(
      success: (data) => data.items,
      error: (failure) => throw failure,
    );
  }
}
