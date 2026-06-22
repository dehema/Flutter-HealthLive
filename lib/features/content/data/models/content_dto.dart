import 'package:healthlive/features/content/data/models/benefit_point_dto.dart';

class ContentDto {
  const ContentDto({
    required this.id,
    required this.title,
    required this.summary,
    required this.coverUrl,
    required this.categoryId,
    required this.tags,
    required this.points,
    required this.body,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String summary;
  final String coverUrl;
  final int categoryId;
  final List<String> tags;
  final List<BenefitPointDto> points;
  final String body;
  final String updatedAt;

  factory ContentDto.fromJson(Map<String, dynamic> json) {
    final rawPoints = json['points'];
    return ContentDto(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? '',
      categoryId: _readCategoryId(json),
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

  static int _readCategoryId(Map<String, dynamic> json) {
    final categoryId = json['category_id'];
    if (categoryId is num) {
      return categoryId.toInt();
    }
    return _categoryCodeToId(json['category']?.toString());
  }

  static int _categoryCodeToId(String? code) {
    return switch (code) {
      'lifestyle' => 1,
      'exercise' => 2,
      'diet' => 3,
      _ => 1,
    };
  }
}
