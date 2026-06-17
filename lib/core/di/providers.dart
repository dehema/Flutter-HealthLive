import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/network/api_client.dart';
import 'package:healthlive/core/storage/local_storage.dart';
import 'package:healthlive/core/storage/secure_storage.dart';
import 'package:healthlive/features/content/data/datasources/content_mock_datasource.dart';
import 'package:healthlive/features/content/data/datasources/content_remote_datasource.dart';
import 'package:healthlive/features/content/data/repositories/content_repository_impl.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';
import 'package:healthlive/features/content/domain/usecases/get_content_detail.dart';
import 'package:healthlive/features/content/domain/usecases/get_contents_by_category.dart';
import 'package:healthlive/features/content/domain/usecases/search_contents.dart';
import 'package:healthlive/features/favorites/data/datasources/favorites_local_datasource.dart';
import 'package:healthlive/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:healthlive/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:healthlive/features/home/data/repositories/home_repository_impl.dart';
import 'package:healthlive/features/home/domain/repositories/home_repository.dart';
import 'package:healthlive/features/home/domain/usecases/get_home_data.dart';
import 'package:healthlive/features/search/data/datasources/search_history_local_datasource.dart';

final appConfigProvider = Provider<AppConfig>(
  (ref) => AppConfig.fromEnvironment(),
);

final localStorageProvider = Provider<LocalStorage>((ref) => LocalStorage());

final secureStorageProvider = Provider<SecureStorage>((ref) => SecureStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(
    config: ref.watch(appConfigProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final contentMockDataSourceProvider = Provider<ContentMockDataSource>(
  (ref) => ContentMockDataSource(),
);

final contentRemoteDataSourceProvider = Provider<ContentRemoteDataSource>(
  (ref) => ContentRemoteDataSource(apiClient: ref.watch(apiClientProvider)),
);

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(contentRemoteDataSourceProvider),
    mockDataSource: ref.watch(contentMockDataSourceProvider),
  );
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    config: ref.watch(appConfigProvider),
    remoteDataSource: ref.watch(contentRemoteDataSourceProvider),
    mockDataSource: ref.watch(contentMockDataSourceProvider),
  );
});

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => FavoritesLocalDataSource(
    localStorage: ref.watch(localStorageProvider),
  ),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(
    localDataSource: ref.watch(favoritesLocalDataSourceProvider),
    contentRepository: ref.watch(contentRepositoryProvider),
  );
});

final searchHistoryLocalDataSourceProvider =
    Provider<SearchHistoryLocalDataSource>(
  (ref) => SearchHistoryLocalDataSource(
    localStorage: ref.watch(localStorageProvider),
  ),
);

final getHomeDataProvider = Provider<GetHomeData>(
  (ref) => GetHomeData(ref.watch(homeRepositoryProvider)),
);

final getContentDetailProvider = Provider<GetContentDetail>(
  (ref) => GetContentDetail(ref.watch(contentRepositoryProvider)),
);

final getContentsByCategoryProvider = Provider<GetContentsByCategory>(
  (ref) => GetContentsByCategory(ref.watch(contentRepositoryProvider)),
);

final searchContentsProvider = Provider<SearchContents>(
  (ref) => SearchContents(ref.watch(contentRepositoryProvider)),
);
