import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/home/domain/entities/home_data.dart';

final homeDataProvider = AsyncNotifierProvider<HomeDataNotifier, HomeData>(
  HomeDataNotifier.new,
);

class HomeDataNotifier extends AsyncNotifier<HomeData> {
  @override
  Future<HomeData> build() => _load();

  Future<HomeData> _load() async {
    final useCase = ref.read(getHomeDataProvider);
    final result = await useCase();
    return result.when(
      success: (data) => data,
      error: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }
}
