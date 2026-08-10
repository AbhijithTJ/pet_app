import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  static const String _kSelectedCategories = 'selected_categories';

  /// Save selected category IDs
  Future<void> saveSelectedCategories(List<String> categoryIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_kSelectedCategories, categoryIds);
  }

  /// Load selected category IDs
  Future<List<String>> getSelectedCategories() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kSelectedCategories) ?? [];
  }
}
