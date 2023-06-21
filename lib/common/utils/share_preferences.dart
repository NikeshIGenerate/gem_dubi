import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageRepo {
  LocalStorageRepo._();

  static LocalStorageRepo? _instance;

  factory LocalStorageRepo.instance() {
    _instance ??= LocalStorageRepo._();

    return _instance!;
  }

  final shared = SharedPreferences.getInstance();

  Future<bool> clear() async => (await shared).clear();

  Future<void> reload() async => (await shared).reload();

  Future<bool> containsKey(String key) async => (await shared).containsKey(key);

  Object? get(String key) async => (await shared).get(key);

  Future<bool?> getBool(String key) async => (await shared).getBool(key);

  Future<double?> getDouble(String key) async => (await shared).getDouble(key);

  Future<int?> getInt(String key) async => (await shared).getInt(key);

  Future<Set<String>> getKeys() async => (await shared).getKeys();

  Future<String?> getString(String key) async => (await shared).getString(key);

  Future<List<String>?> getStringList(String key) async =>
      (await shared).getStringList(key);

  Future<bool> remove(String key) async => (await shared).remove(key);

  Future<bool> setBool(String key, bool value) async =>
      (await shared).setBool(key, value);

  Future<bool> setDouble(String key, double value) async =>
      (await shared).setDouble(key, value);

  Future<bool> setInt(String key, int value) async =>
      (await shared).setInt(key, value);

  Future<bool> setString(String key, String value) async =>
      (await shared).setString(key, value);

  Future<bool> setStringList(String key, List<String> value) async =>
      (await shared).setStringList(key, value);
}
