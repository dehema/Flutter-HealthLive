import 'package:healthlive/features/content/data/models/benefit_point_dto.dart';

class ContentDto {
  const ContentDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.coverUrl,
    required this.category,
    required this.tags,
    required this.points,
    required this.body,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String coverUrl;
  final String category;
  final List<String> tags;
  final List<BenefitPointDto> points;
  final String body;
  final String updatedAt;

  factory ContentDto.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'];
    return ContentDto(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? '',
      category: json['category'] as String? ?? 'lifestyle',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((item) => item.toString())
          .toList(),
      points: rawPoints is List<dynamic>
          ? rawPoints
              .whereType<Map<String, dynamic>>()
              .map(BenefitPointDto.fromJson)
              .toList()
          : const [],
      body: json['body'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}
