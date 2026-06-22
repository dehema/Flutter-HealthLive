import 'package:equatable/equatable.dart';

/// 内容分类实体，对应 `categories` 表及 `assets/data/categories.json`。
class Category extends Equatable {
  const Category({
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

  @override
  List<Object?> get props => [id, code, name, description, icon, color, sortOrder];
}
