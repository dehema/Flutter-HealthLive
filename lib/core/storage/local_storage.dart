import 'package:hive_flutter/hive_flutter.dart';
import 'package:healthlive/core/storage/hive_boxes.dart';

class LocalStorage {
  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(HiveBoxes.favorites);
    await Hive.openBox<dynamic>(HiveBoxes.searchHistory);
  }

  Box<dynamic> get favoritesBox => Hive.box<dynamic>(HiveBoxes.favorites);

  Box<dynamic> get searchHistoryBox =>
      Hive.box<dynamic>(HiveBoxes.searchHistory);
}
