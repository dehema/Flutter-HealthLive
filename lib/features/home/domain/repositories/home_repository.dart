import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/home/domain/entities/home_data.dart';

abstract class HomeRepository {
  Future<Result<HomeData>> getHomeData();
}
