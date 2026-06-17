import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/home/domain/entities/home_data.dart';
import 'package:healthlive/features/home/domain/repositories/home_repository.dart';

class GetHomeData {
  const GetHomeData(this._repository);

  final HomeRepository _repository;

  Future<Result<HomeData>> call() => _repository.getHomeData();
}
