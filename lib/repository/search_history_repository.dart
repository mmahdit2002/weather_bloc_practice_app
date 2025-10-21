import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryRepository {
  static const _historyKey = 'search_history';
  static const _maxHistoryLength = 5;

  Future<void> addSearchTerm(String city) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];

    history.removeWhere((item) => item.toLowerCase() == city.toLowerCase());
    history.insert(0, city);

    if (history.length > _maxHistoryLength) {
      history.removeLast();
    }

    await prefs.setStringList(_historyKey, history);
  }

  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? [];
  }
}
