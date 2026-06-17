import 'package:healthlive/features/content/data/models/content_dto.dart';

class HomeDto {
  const HomeDto({
    required this.dailyTip,
    required this.recommended,
  });

  final DailyTipDto dailyTip;
  final List<ContentDto> recommended;

  factory HomeDto.fromJson(Map<String, dynamic> json) {
    final rawRecommended = json['recommended'];
    return HomeDto(
      dailyTip: DailyTipDto.fromJson(
        json['daily_tip'] as Map<String, dynamic>? ?? {},
      ),
      recommended: rawRecommended is List<dynamic>
          ? rawRecommended
              .whereType<Map<String, dynamic>>()
              .map(ContentDto.fromJson)
              .toList()
          : const [],
    );
  }
}

class DailyTipDto {
  const DailyTipDto({
    required this.contentId,
    required this.title,
    required this.summary,
  });

  final String contentId;
  final String title;
  final String summary;

  factory DailyTipDto.fromJson(Map<String, dynamic> json) {
    return DailyTipDto(
      contentId: json['content_id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
    );
  }
}
