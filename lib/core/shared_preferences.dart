import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> saveData(String path, String json) async {
    await _prefs.setString(path, json);
  }

  bool isSaved(path) {
    return _prefs.containsKey(path);
  }

  String? getData(String path) {
    return _prefs.getString(path);
  }

  static Future<void> clearAll() async {
    SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.clear();
  }
}
