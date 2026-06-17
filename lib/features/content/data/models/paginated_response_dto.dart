import 'package:healthlive/features/content/data/models/content_dto.dart';

class PaginatedResponseDto {
  const PaginatedResponseDto({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
  });

  final List<ContentDto> items;
  final int total;
  final int page;
  final int pageSize;

  factory PaginatedResponseDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return PaginatedResponseDto(
      items: rawItems is List<dynamic>
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(ContentDto.fromJson)
              .toList()
          : const [],
      total: json['total'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? 20,
    );
  }
}
