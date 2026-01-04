// services/notes_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class NotesManager {
  static String _key(String id) => 'note_$id';

  static Future<void> saveNote(String id, String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key(id), note);
  }

  static Future<String?> loadNote(String id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(id));
  }
}
