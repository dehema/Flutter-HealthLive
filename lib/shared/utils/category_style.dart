import 'package:flutter/material.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/features/category/domain/entities/category.dart';

class CategoryStyle {
  const CategoryStyle._();

  static Color colorOf(Category category) {
    if (category.color.isNotEmpty) {
      return _colorFromHex(category.color);
    }
    return AppColors.primary;
  }

  static IconData iconOf(Category category) {
    return _iconFromName(category.icon);
  }

  static Color colorOfId(int categoryId, List<Category> categories) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return colorOf(category);
      }
    }
    return AppColors.primary;
  }

  static IconData iconOfId(int categoryId, List<Category> categories) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return iconOf(category);
      }
    }
    return Icons.category_outlined;
  }

  static Category? findById(int categoryId, List<Category> categories) {
    for (final category in categories) {
      if (category.id == categoryId) {
        return category;
      }
    }
    return null;
  }

  static Color _colorFromHex(String hex) {
    final normalized = hex.replaceFirst('#', '');
    if (normalized.length != 6) {
      return AppColors.primary;
    }
    return Color(int.parse('FF$normalized', radix: 16));
  }

  static IconData _iconFromName(String name) {
    return switch (name) {
      'bedtime_outlined' => Icons.bedtime_outlined,
      'directions_run_outlined' => Icons.directions_run_outlined,
      'restaurant_outlined' => Icons.restaurant_outlined,
      _ => Icons.category_outlined,
    };
  }
}
