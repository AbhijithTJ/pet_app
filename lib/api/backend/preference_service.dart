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

  static const String _kLikedArticles = 'liked_articles';

  /// Save liked article IDs
  Future<void> saveLikedArticle(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedList = prefs.getStringList(_kLikedArticles) ?? [];
    if (!likedList.contains(articleId)) {
      likedList.add(articleId);
      await prefs.setStringList(_kLikedArticles, likedList);
    }
  }

  /// Remove liked article ID
  Future<void> removeLikedArticle(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedList = prefs.getStringList(_kLikedArticles) ?? [];
    if (likedList.contains(articleId)) {
      likedList.remove(articleId);
      await prefs.setStringList(_kLikedArticles, likedList);
    }
  }

  /// Check if article is liked
  Future<bool> isArticleLiked(String articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedList = prefs.getStringList(_kLikedArticles) ?? [];
    return likedList.contains(articleId);
  }
}
