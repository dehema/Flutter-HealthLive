import 'package:healthlive/core/utils/result.dart';
import 'package:healthlive/features/content/domain/entities/benefit_content.dart';
import 'package:healthlive/features/content/domain/repositories/content_repository.dart';

class GetContentDetail {
  const GetContentDetail(this._repository);

  final ContentRepository _repository;

  Future<Result<BenefitContent>> call(String id) {
    return _repository.getContentDetail(id);
  }
}
