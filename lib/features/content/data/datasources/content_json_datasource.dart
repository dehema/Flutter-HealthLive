import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/data/models/benefit_point_dto.dart';
import 'package:healthlive/features/content/data/models/content_dto.dart';
import 'package:healthlive/features/content/data/models/paginated_response_dto.dart';
import 'package:healthlive/features/home/data/models/home_dto.dart';

/// 从 `assets/data/*.json` 按 PostgreSQL 表结构读取并 JOIN，组装为 API 同构 DTO。
class ContentJsonDataSource {
  static const _dataDir = 'assets/data';
  static const _simulateLatency = Duration(milliseconds: 200);

  List<ContentDto>? _contentsCache;
  HomeDto? _homeCache;

  Future<void> _ensureLoaded() async {
    if (_contentsCache != null) return;

    final contentsRows = await _loadTable('contents.json', 'contents');
    final pointsRows =
        await _loadTable('content_benefit_points.json', 'content_benefit_points');
    final tagRows = await _loadTable('content_tags.json', 'content_tags');

    final pointsByContent = _groupByContentId(pointsRows);
    final tagsByContent = _groupByContentId(tagRows);

    _contentsCache = contentsRows
        .where(_isPublishedContent)
        .map(
          (row) => _toContentDto(
            row,
            pointsByContent[_contentIdKey(row['id'])] ?? const [],
            tagsByContent[_contentIdKey(row['id'])] ?? const [],
          ),
        )
        .toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  Future<HomeDto> fetchHome() async {
    await Future<void>.delayed(_simulateLatency);
    if (_homeCache != null) return _homeCache!;

    await _ensureLoaded();
    final byId = {for (final c in _contentsCache!) c.id: c};

    final dailyTipRows = await _loadTable('daily_tips.json', 'daily_tips');
    dailyTipRows.sort((a, b) {
      final da = a['tip_date']?.toString() ?? '';
      final db = b['tip_date']?.toString() ?? '';
      return db.compareTo(da);
    });
    final tipRow = dailyTipRows.isNotEmpty ? dailyTipRows.first : null;

    final recRows =
        await _loadTable('home_recommendations.json', 'home_recommendations');
    final recommended = recRows
        .where(_isPublishedRecommendation)
        .toList()
      ..sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );

    _homeCache = HomeDto(
      dailyTip: tipRow != null
          ? DailyTipDto(
              contentId: _contentIdKey(tipRow['content_id']),
              title: tipRow['title']?.toString() ?? '',
              summary: tipRow['summary']?.toString() ?? '',
            )
          : const DailyTipDto(contentId: '', title: '', summary: ''),
      recommended: recommended
          .map((r) => byId[_contentIdKey(r['content_id'])])
          .whereType<ContentDto>()
          .toList(),
    );
    return _homeCache!;
  }

  Future<PaginatedResponseDto> fetchByCategory({
    required ContentCategory category,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_simulateLatency);
    await _ensureLoaded();
    final filtered = _contentsCache!
        .where((item) => item.category == category.apiValue)
        .toList();
    return _paginate(filtered, page, pageSize);
  }

  Future<ContentDto?> fetchById(String id) async {
    await Future<void>.delayed(_simulateLatency);
    await _ensureLoaded();
    for (final item in _contentsCache!) {
      if (item.id == id) return item;
    }
    return null;
  }

  Future<PaginatedResponseDto> search({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(_simulateLatency);
    await _ensureLoaded();
    final normalized = keyword.trim().toLowerCase();
    if (normalized.isEmpty) {
      return _paginate(const [], page, pageSize);
    }

    final filtered = _contentsCache!.where((item) {
      final haystack =
          '${item.title} ${item.summary} ${item.tags.join(' ')}'.toLowerCase();
      return haystack.contains(normalized);
    }).toList();
    return _paginate(filtered, page, pageSize);
  }

  Future<List<ContentDto>> getAll() async {
    await _ensureLoaded();
    return List<ContentDto>.from(_contentsCache!);
  }

  /// 读取 `users.json`（登录功能预留，JSON 模式暂未使用）
  Future<List<Map<String, dynamic>>> loadUsers() =>
      _loadTable('users.json', 'users');

  /// 读取 `user_favorites.json`（云端收藏预留，当前收藏走 Hive）
  Future<List<Map<String, dynamic>>> loadUserFavorites() =>
      _loadTable('user_favorites.json', 'user_favorites');

  Future<List<Map<String, dynamic>>> _loadTable(
    String fileName,
    String tableKey,
  ) async {
    final raw = await rootBundle.loadString('$_dataDir/$fileName');
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) return const [];

    final rows = json[tableKey];
    if (rows is! List) return const [];
    return rows.whereType<Map<String, dynamic>>().toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupByContentId(
    List<Map<String, dynamic>> rows,
  ) {
    final map = <String, List<Map<String, dynamic>>>{};
    for (final row in rows) {
      final key = _contentIdKey(row['content_id']);
      map.putIfAbsent(key, () => []).add(row);
    }
    for (final list in map.values) {
      list.sort(
        (a, b) => (a['sort_order'] as num? ?? 0)
            .compareTo(b['sort_order'] as num? ?? 0),
      );
    }
    return map;
  }

  bool _isPublishedContent(Map<String, dynamic> row) {
    final published = row['published'];
    if (published is bool) return published;
    final status = row['status']?.toString();
    if (status != null) return status == 'published';
    return true;
  }

  bool _isPublishedRecommendation(Map<String, dynamic> row) {
    final published = row['published'];
    if (published is bool) return published;
    final active = row['is_active'];
    if (active is bool) return active;
    return true;
  }

  ContentDto _toContentDto(
    Map<String, dynamic> row,
    List<Map<String, dynamic>> pointRows,
    List<Map<String, dynamic>> tagRows,
  ) {
    return ContentDto(
      id: _contentIdKey(row['id']),
      title: row['title']?.toString() ?? '',
      summary: row['summary']?.toString() ?? '',
      coverUrl: row['cover_url']?.toString() ?? '',
      category: row['category']?.toString() ?? 'lifestyle',
      tags: tagRows.map((t) => t['tag']?.toString() ?? '').where((t) => t.isNotEmpty).toList(),
      points: pointRows
          .map(
            (p) => BenefitPointDto(
              title: p['title']?.toString() ?? '',
              description: p['description']?.toString() ?? '',
              icon: p['icon']?.toString(),
            ),
          )
          .toList(),
      body: row['body']?.toString() ?? '',
      updatedAt: row['updated_at']?.toString() ?? '',
    );
  }

  String _contentIdKey(Object? id) => id?.toString() ?? '';

  PaginatedResponseDto _paginate(
    List<ContentDto> filtered,
    int page,
    int pageSize,
  ) {
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    final slice =
        start >= filtered.length ? <ContentDto>[] : filtered.sublist(start, end);

    return PaginatedResponseDto(
      items: slice,
      total: filtered.length,
      page: page,
      pageSize: pageSize,
    );
  }
}
