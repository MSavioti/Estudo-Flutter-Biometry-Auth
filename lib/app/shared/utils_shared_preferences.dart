import 'package:shared_preferences/shared_preferences.dart';

class UtilsSharedPreferences {
  static final UtilsSharedPreferences _instance = UtilsSharedPreferences._();

  UtilsSharedPreferences._();

  static UtilsSharedPreferences get instance => _instance;

  Future<bool> saveString(String key, String value) async {
    try {
      final _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setString(key, value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String> loadString(String key) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    String? _value = '';

    if (_sharedPreferences.getKeys().contains(key)) {
      _value = _sharedPreferences.getString(key);
    }

    if ((_value == null) || (_value.isEmpty)) {
      return '';
    }

    return _value;
  }

  Future<bool> saveBool(String key, bool value) async {
    try {
      final _sharedPreferences = await SharedPreferences.getInstance();
      await _sharedPreferences.setBool(key, value);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> loadBool(String key) async {
    final _sharedPreferences = await SharedPreferences.getInstance();
    bool? _value = false;

    if (_sharedPreferences.getKeys().contains(key)) {
      _value = _sharedPreferences.getBool(key);
    }

    if (_value == null) {
      return false;
    }

    return _value;
  }
}
