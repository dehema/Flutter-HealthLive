import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = '网络连接失败，请检查网络后重试']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = '服务器异常，请稍后重试']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = '内容不存在或已下线']);
}

final class CacheFailure extends Failure {
  const CacheFailure([super.message = '本地数据读取失败']);
}

final class UnknownFailure extends Failure {
  const UnknownFailure([super.message = '未知错误，请稍后重试']);
}
