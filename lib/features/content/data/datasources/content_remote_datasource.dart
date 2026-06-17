import 'package:dio/dio.dart';
import 'package:healthlive/core/constants/api_constants.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/core/network/api_client.dart';
import 'package:healthlive/core/network/api_paths.dart';
import 'package:healthlive/features/content/data/models/content_dto.dart';
import 'package:healthlive/features/content/data/models/paginated_response_dto.dart';
import 'package:healthlive/features/home/data/models/home_dto.dart';

class ContentRemoteDataSource {
  ContentRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<HomeDto> fetchHome() async {
    try {
      final data = await _apiClient.getMap(ApiPaths.home);
      return HomeDto.fromJson(data);
    } on DioException catch (error) {
      throw _apiClient.rethrowAsAppException(error);
    }
  }

  Future<PaginatedResponseDto> fetchByCategory({
    required ContentCategory category,
    required int page,
    required int pageSize,
  }) async {
    try {
      final data = await _apiClient.getMap(
        ApiPaths.contents,
        queryParameters: {
          'category': category.apiValue,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedResponseDto.fromJson(data);
    } on DioException catch (error) {
      throw _apiClient.rethrowAsAppException(error);
    }
  }

  Future<ContentDto> fetchById(String id) async {
    try {
      final data = await _apiClient.getMap(ApiPaths.contentDetail(id));
      return ContentDto.fromJson(data);
    } on DioException catch (error) {
      throw _apiClient.rethrowAsAppException(error);
    }
  }

  Future<PaginatedResponseDto> search({
    required String keyword,
    required int page,
    int pageSize = ApiConstants.defaultPageSize,
  }) async {
    try {
      final data = await _apiClient.getMap(
        ApiPaths.search,
        queryParameters: {
          'q': keyword,
          'page': page,
          'page_size': pageSize,
        },
      );
      return PaginatedResponseDto.fromJson(data);
    } on DioException catch (error) {
      throw _apiClient.rethrowAsAppException(error);
    }
  }
}
