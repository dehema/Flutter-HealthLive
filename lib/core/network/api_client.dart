import 'package:dio/dio.dart';
import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/constants/api_constants.dart';
import 'package:healthlive/core/errors/app_exception.dart';
import 'package:healthlive/core/network/api_interceptor.dart';
import 'package:healthlive/core/storage/secure_storage.dart';

class ApiClient {
  ApiClient({
    required AppConfig config,
    required SecureStorage secureStorage,
    Dio? dio,
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: config.apiBaseUrl,
                connectTimeout: ApiConstants.connectTimeout,
                receiveTimeout: ApiConstants.receiveTimeout,
                headers: {'Content-Type': 'application/json'},
              ),
            ) {
    _dio.interceptors.add(
      ApiInterceptor(config: config, secureStorage: secureStorage),
    );
  }

  final Dio _dio;

  Dio get dio => _dio;

  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get<dynamic>(
      path,
      queryParameters: queryParameters,
    );
    return _unwrapResponse(response.data);
  }

  Future<Map<String, dynamic>> postMap(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.post<dynamic>(path, data: data);
    return _unwrapResponse(response.data);
  }

  Future<Map<String, dynamic>> deleteMap(String path) async {
    final response = await _dio.delete<dynamic>(path);
    return _unwrapResponse(response.data);
  }

  Map<String, dynamic> _unwrapResponse(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      if (raw.containsKey('data') && raw['data'] is Map<String, dynamic>) {
        return raw['data'] as Map<String, dynamic>;
      }
      return raw;
    }
    throw const AppException(message: '响应格式错误');
  }

  Never rethrowAsAppException(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (error.error is ApiBusinessException) {
      throw error.error as ApiBusinessException;
    }

    if (data is Map<String, dynamic> && data['message'] is String) {
      throw AppException(
        message: data['message'] as String,
        statusCode: statusCode,
      );
    }

    switch (statusCode) {
      case 400:
        throw AppException(message: '请求参数错误', statusCode: statusCode);
      case 401:
        throw AppException(message: '登录已过期，请重新登录?', statusCode: statusCode);
      case 404:
        throw AppException(message: '资源不存在?', statusCode: statusCode);
      default:
        throw AppException(
          message: error.message ?? '网络请求失败',
          statusCode: statusCode,
        );
    }
  }
}
