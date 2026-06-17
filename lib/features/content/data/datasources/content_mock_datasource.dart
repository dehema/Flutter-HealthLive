import 'package:healthlive/core/constants/content_category.dart';
import 'package:healthlive/features/content/data/models/benefit_point_dto.dart';
import 'package:healthlive/features/content/data/models/content_dto.dart';
import 'package:healthlive/features/content/data/models/paginated_response_dto.dart';
import 'package:healthlive/features/home/data/models/home_dto.dart';

/// 本地 Mock 数据源，在后端未就绪`USE_MOCK=true` 时使用
class ContentMockDataSource {
  static final List<ContentDto> _allContents = [
    ContentDto(
      id: '1',
      title: '规律早睡的五个好处',
      summary: '固定入睡时间有助于调节生物钟，提升第二天的精神状态',
      coverUrl: '',
      category: ContentCategory.lifestyle.apiValue,
      tags: ['睡眠', '作息'],
      points: const [
        BenefitPointDto(
          title: '改善睡眠质量',
          description: '规律作息帮助大脑建立稳定的睡眠节律',
          icon: 'sleep',
        ),
        BenefitPointDto(
          title: '提升专注力',
          description: '充足睡眠后，注意力与记忆力明显增强',
          icon: 'focus',
        ),
      ],
      body: '''
## 为什么建议早睡?

保持 **22:30 前入睡** 能让身体进入深度修复阶段

- 减少熬夜带来的内分泌紊乱
- 降低焦虑与情绪波动
- 帮助维持健康体重
''',
      updatedAt: '2026-06-10T08:00:00Z',
    ),
    ContentDto(
      id: '2',
      title: '晨间散步如何开启活力一天',
      summary: '清晨适度活动可以促进血液循环，让身体更快苏醒',
      coverUrl: '',
      category: ContentCategory.exercise.apiValue,
      tags: ['有氧', '晨练'],
      points: const [
        BenefitPointDto(
          title: '温和唤醒身体',
          description: '低强度活动避免刚起床时心肺负担过大',
          icon: 'walk',
        ),
        BenefitPointDto(
          title: '改善情绪',
          description: '晨光与活动有助于分泌让人愉悦的神经递质',
          icon: 'mood',
        ),
      ],
      body: '''
## 晨间散步建议

每天 **15**0 分钟** 即可，不必追求强度**

1. 起床后先补水
2. 以能轻松交谈的速度行走
3. 结束后做简单拉伸
''',
      updatedAt: '2026-06-11T08:00:00Z',
    ),
    ContentDto(
      id: '3',
      title: '均衡早餐的重要性',
      summary: '合理搭配蛋白质、碳水与膳食纤维，为上午提供持续能量',
      coverUrl: '',
      category: ContentCategory.diet.apiValue,
      tags: ['早餐', '营养'],
      points: const [
        BenefitPointDto(
          title: '稳定血糖',
          description: '避免上午出现头晕、乏力等低血糖反应',
          icon: 'energy',
        ),
        BenefitPointDto(
          title: '控制午餐过量',
          description: '高质量早餐有助于减少午间暴饮暴食',
          icon: 'balance',
        ),
      ],
      body: '''
## 早餐搭配参考

- 优质蛋白：鸡蛋、牛奶、豆类
- 复合碳水：燕麦、全麦面食
- 维生素：当季水果或蔬菜
''',
      updatedAt: '2026-06-12T08:00:00Z',
    ),
    ContentDto(
      id: '4',
      title: '午后拉伸缓解久坐疲劳',
      summary: '简短拉伸能放松颈肩腰背，改善久坐带来的僵硬感',
      coverUrl: '',
      category: ContentCategory.exercise.apiValue,
      tags: ['拉伸', '办公'],
      points: const [
        BenefitPointDto(
          title: '缓解肌肉紧张',
          description: '针对颈肩与髋屈肌的拉伸效果显著',
          icon: 'stretch',
        ),
      ],
      body: '每工**45分钟** 起身活动 3分钟',
      updatedAt: '2026-06-09T08:00:00Z',
    ),
    ContentDto(
      id: '5',
      title: '每天喝够水的小技巧',
      summary: '充足饮水有助于代谢、皮肤状态与精力维持',
      coverUrl: '',
      category: ContentCategory.diet.apiValue,
      tags: ['饮水', '习惯'],
      points: const [
        BenefitPointDto(
          title: '提升代谢效率',
          description: '身体各项代谢反应都需要水作为介质',
          icon: 'water',
        ),
      ],
      body: '建议每天 **1500-2000 ml**，分次饮用',
      updatedAt: '2026-06-08T08:00:00Z',
    ),
    ContentDto(
      id: '6',
      title: '固定起床时间的力',
      summary: '即使周末也尽量保持相近的起床时刻，生物钟会更稳定',
      coverUrl: '',
      category: ContentCategory.lifestyle.apiValue,
      tags: ['早起', '生物钟'],
      points: const [
        BenefitPointDto(
          title: '减少社交时差',
          description: '周末补觉过多反而会让周一更加疲惫',
          icon: 'clock',
        ),
      ],
      body: '尝试将起床时间波动控制在 **30 分钟以内**',
      updatedAt: '2026-06-07T08:00:00Z',
    ),
  ];

  Future<HomeDto> fetchHome() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return HomeDto(
      dailyTip: const DailyTipDto(
        contentId: '1',
        title: '今日一知：规律早睡',
        summary: '固定入睡时间有助于调节生物钟，提升第二天的精神状态',
      ),
      recommended: _allContents.take(4).toList(),
    );
  }

  Future<PaginatedResponseDto> fetchByCategory({
    required ContentCategory category,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final filtered = _allContents
        .where((item) => item.category == category.apiValue)
        .toList();
    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    final slice = start >= filtered.length
        ? <ContentDto>[]
        : filtered.sublist(start, end);

    return PaginatedResponseDto(
      items: slice,
      total: filtered.length,
      page: page,
      pageSize: pageSize,
    );
  }

  Future<ContentDto?> fetchById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    for (final item in _allContents) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  Future<PaginatedResponseDto> search({
    required String keyword,
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final normalized = keyword.trim().toLowerCase();
    final filtered = _allContents.where((item) {
      final haystack =
          '${item.title} ${item.summary} ${item.tags.join(' ')}'.toLowerCase();
      return haystack.contains(normalized);
    }).toList();

    final start = (page - 1) * pageSize;
    final end = (start + pageSize).clamp(0, filtered.length);
    final slice = start >= filtered.length
        ? <ContentDto>[]
        : filtered.sublist(start, end);

    return PaginatedResponseDto(
      items: slice,
      total: filtered.length,
      page: page,
      pageSize: pageSize,
    );
  }

  List<ContentDto> getAll() => List<ContentDto>.from(_allContents);
}
