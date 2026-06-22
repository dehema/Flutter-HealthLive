import 'package:healthlive/features/category/data/models/category_dto.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';

class CategoryMapper {
  const CategoryMapper._();

  static Category toEntity(CategoryDto dto) {
    return Category(
      id: dto.id,
      code: dto.code,
      name: dto.name,
      description: dto.description,
      icon: dto.icon,
      color: dto.color,
      sortOrder: dto.sortOrder,
    );
  }
}
