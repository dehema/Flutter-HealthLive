class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
    this.code,
  });

  final String message;
  final int? statusCode;
  final int? code;

  @override
  String toString() => 'AppException($statusCode, $code): $message';
}

class ApiBusinessException extends AppException {
  const ApiBusinessException({
    required super.message,
    super.code,
  });
}
