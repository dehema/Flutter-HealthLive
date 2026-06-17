import 'package:healthlive/features/content/data/mappers/content_mapper.dart';
import 'package:healthlive/features/home/data/models/home_dto.dart';
import 'package:healthlive/features/home/domain/entities/daily_tip.dart';
import 'package:healthlive/features/home/domain/entities/home_data.dart';

class HomeMapper {
  const HomeMapper._();

  static HomeData toEntity(HomeDto dto) {
    return HomeData(
      dailyTip: DailyTip(
        contentId: dto.dailyTip.contentId,
        title: dto.dailyTip.title,
        summary: dto.dailyTip.summary,
      ),
      recommended: dto.recommended.map(ContentMapper.toEntity).toList(),
    );
  }
}
