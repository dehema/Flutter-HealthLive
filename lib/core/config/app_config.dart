/// 应用运行时配置，通过 `--dart-define` 注入
class AppConfig {
  const AppConfig({
    required this.apiBaseUrl,
    required this.env,
    required this.useMockData,
  });

  final String apiBaseUrl;
  final String env;
  final bool useMockData;

  bool get isDev => env == 'dev';
  bool get isProd => env == 'prod';

  static AppConfig fromEnvironment() {
    const apiBaseUrl = String.fromEnvironment(
      'API_BASE_URL',
      defaultValue: 'http://10.0.2.2:8080',
    );
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');
    const useMockData = bool.fromEnvironment('USE_MOCK', defaultValue: true);

    return AppConfig(
      apiBaseUrl: apiBaseUrl,
      env: env,
      useMockData: useMockData,
    );
  }
}
