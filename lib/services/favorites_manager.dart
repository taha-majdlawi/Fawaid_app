import 'package:shared_preferences/shared_preferences.dart';

class FavoritesManager {
  static const String key = 'favorites';

  static Future<List<String>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  static Future<void> saveFavorites(List<String> list) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, list);
  }
}
