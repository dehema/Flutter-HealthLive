import 'package:healthlive/core/errors/app_exception.dart';
import 'package:healthlive/core/errors/failure.dart';

class ExceptionMapper {
  const ExceptionMapper._();

  static Failure toFailure(Object error) {
    if (error is AppException) {
      return switch (error.statusCode) {
        404 => NotFoundFailure(error.message),
        401 => ServerFailure(error.message),
        500 => ServerFailure(error.message),
        _ => NetworkFailure(error.message),
      };
    }
    return const UnknownFailure();
  }
}
