import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late SharedPreferences _preferences;

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async {
    return await _preferences.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences.getBool(key);
  }

  static Future<bool> setString(String key, String value) async {
    return await _preferences.setString(key, value);
  }

  static String? getString(String key) {
    return _preferences.getString(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return await _preferences.setInt(key, value);
  }

  static int? getInt(String key) {
    return _preferences.getInt(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return await _preferences.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  static Future<bool> clear() async {
    return await _preferences.clear();
  }

  static Future<bool> remove(String key) async {
    return await _preferences.remove(key);
  }

// Add similar methods for other data types (int, String, etc.) as needed.
}
