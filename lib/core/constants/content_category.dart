/// 内容分类，与 Go 后端 `category` 字段保持一致
enum ContentCategory {
  lifestyle,
  exercise,
  diet;

  String get apiValue => name;

  String get displayName => switch (this) {
        ContentCategory.lifestyle => '作息',
        ContentCategory.exercise => '运动',
        ContentCategory.diet => '饮食',
      };

  static ContentCategory fromApi(String value) {
    return ContentCategory.values.firstWhere(
      (category) => category.apiValue == value,
      orElse: () => ContentCategory.lifestyle,
    );
  }
}
