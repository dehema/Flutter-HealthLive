import 'package:healthlive/core/config/app_config.dart';
import 'package:healthlive/core/utils/exception_mapper.dart';
import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/data/datasources/content_json_datasource.dart';
import 'package:healthlive/features/content/data/datasources/content_remote_datasource.dart';
import 'package:healthlive/features/home/data/mappers/home_mapper.dart';
import 'package:healthlive/features/home/domain/entities/home_data.dart';
import 'package:healthlive/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required AppConfig config,
    required ContentRemoteDataSource remoteDataSource,
    required ContentJsonDataSource jsonDataSource,
  })  : _config = config,
        _remoteDataSource = remoteDataSource,
        _jsonDataSource = jsonDataSource;

  final AppConfig _config;
  final ContentRemoteDataSource _remoteDataSource;
  final ContentJsonDataSource _jsonDataSource;

  @override
  Future<Result<HomeData>> getHomeData() async {
    try {
      final dto = _config.usesJsonContent
          ? await _jsonDataSource.fetchHome()
          : await _remoteDataSource.fetchHome();
      return Success(HomeMapper.toEntity(dto));
    } catch (error) {
      return Error(ExceptionMapper.toFailure(error));
    }
  }
}
