import 'package:healthlive/core/storage/hive_boxes.dart';
import 'package:healthlive/core/storage/local_storage.dart';

class SearchHistoryLocalDataSource {
  SearchHistoryLocalDataSource({required LocalStorage localStorage})
      : _localStorage = localStorage;

  final LocalStorage _localStorage;

  static const int maxHistorySize = 10;

  List<String> readHistory() {
    final raw = _localStorage.searchHistoryBox.get(HiveKeys.searchKeywords);
    if (raw is List<dynamic>) {
      return raw.map((item) => item.toString()).toList();
    }
    return <String>[];
  }

  Future<void> addKeyword(String keyword) async {
    final normalized = keyword.trim();
    if (normalized.isEmpty) {
      return;
    }

    final history = readHistory()..remove(normalized);
    history.insert(0, normalized);
    if (history.length > maxHistorySize) {
      history.removeRange(maxHistorySize, history.length);
    }
    await _localStorage.searchHistoryBox.put(
      HiveKeys.searchKeywords,
      history,
    );
  }

  Future<void> clearHistory() async {
    await _localStorage.searchHistoryBox.delete(HiveKeys.searchKeywords);
  }
}
