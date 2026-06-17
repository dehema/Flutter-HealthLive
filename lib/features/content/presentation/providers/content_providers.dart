import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/di/providers.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';

final contentDetailProvider =
    AsyncNotifierProviderFamily<ContentDetailNotifier, BenefitContent, String>(
  ContentDetailNotifier.new,
);

class ContentDetailNotifier extends FamilyAsyncNotifier<BenefitContent, String> {
  @override
  Future<BenefitContent> build(String arg) => _load(arg);

  Future<BenefitContent> _load(String id) async {
    final useCase = ref.read(getContentDetailProvider);
    final result = await useCase(id);
    return result.when(
      success: (data) => data,
      error: (failure) => throw failure,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _load(arg));
  }
}
