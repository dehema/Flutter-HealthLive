import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/errors/app_exception.dart';
import 'package:healthlive/core/storage/secure_storage.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    required AppConfig config,
    required SecureStorage secureStorage,
  })  : _config = config,
        _secureStorage = secureStorage;

  final AppConfig _config;
  final SecureStorage _secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final data = response.data;
    if (data is Map<String, dynamic> && data.containsKey('code')) {
      final code = data['code'];
      if (code is int && code != 0) {
        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            error: ApiBusinessException(
              code: code,
              message: data['message']?.toString() ?? '请求失败',
            ),
          ),
        );
        return;
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_config.isDev) {
      debugPrint('[API] ${err.requestOptions.uri} -> ${err.message}');
    }
    handler.next(err);
  }
}
