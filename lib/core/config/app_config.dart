import 'package:healthlive/core/config/content_data_source.dart';

/// 应用运行时配置，通过 `--dart-define` 注入
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.env,
    required this.contentDataSource,
  });

  final String apiBaseUrl;
  final String env;

  /// 内容数据来源：`json`（本地资产）或 `server`（REST API）
  final ContentDataSource contentDataSource;

  bool get isDev => env == 'dev';
  bool get isProd => env == 'prod';

  bool get usesJsonContent => contentDataSource == ContentDataSource.json;
  bool get usesServerContent => contentDataSource == ContentDataSource.server;

  static AppConfig fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080',
    );
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    return AppConfig(
      apiBaseUrl: apiBaseUrl,
      env: env,
      contentDataSource: ContentDataSource.fromEnvironment(),
    );
  }
}
