class CategoryDto {
  const CategoryDto({
    required this.id,
    required this.code,
    required this.name,
    this.description = '',
    this.icon = '',
    this.color = '',
    this.sortOrder = 0,
  });

  final int id;
  final String code;
  final String name;
  final String description;
  final String icon;
  final String color;
  final int sortOrder;

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      icon: json['icon']?.toString() ?? '',
      color: json['color']?.toString() ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}
