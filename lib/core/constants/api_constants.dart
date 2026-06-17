class ApiConstants {
  ApiConstants._();

  static const String apiVersionPrefix = '/api/v1';
  static const int defaultPageSize = 20;
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration searchDebounce = Duration(milliseconds: 300);
}
