import 'package:flutter/material.dart';
import 'package:healthlive/app/theme/app_colors.dart';
import 'package:healthlive/core/constants/content_category.dart';

class CategoryStyle {
  const CategoryStyle._();

  static Color colorOf(ContentCategory category) {
    return switch (category) {
      ContentCategory.lifestyle => AppColors.lifestyle,
      ContentCategory.exercise => AppColors.exercise,
      ContentCategory.diet => AppColors.diet,
    };
  }

  static IconData iconOf(ContentCategory category) {
    return switch (category) {
      ContentCategory.lifestyle => Icons.bedtime_outlined,
      ContentCategory.exercise => Icons.directions_run_outlined,
      ContentCategory.diet => Icons.restaurant_outlined,
    };
  }
}
