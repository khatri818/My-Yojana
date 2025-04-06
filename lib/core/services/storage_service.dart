import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStorage {
  Future<void> write(SecureStorageItem item);

  Future<void> writeMultiple(List<SecureStorageItem> items);

  Future<void> writeBool(SecureStorageItem<bool> item);

  Future<dynamic> read(String key);

  Future<bool?> readBool(String key);

  Future<void> delete(String key);

  Future<void> deleteAll();

  Future<bool> exists(String key);

  Future<Map<String, dynamic>> readAll();

  Future<bool> containsKey(String key);
}

class SecureStorageItem<T> {
  final String key;
  final T value;

  SecureStorageItem({required this.key, required this.value});
}

class LocalStorageImpl implements LocalStorage {
  final SharedPreferences _prefs;

  LocalStorageImpl(this._prefs);

  @override
  Future<void> write(SecureStorageItem item) async {
    await _prefs.setString(item.key, item.value);
  }

  @override
  Future<void> writeBool(SecureStorageItem item) async {
    await _prefs.setBool(item.key, item.value);
  }

  @override
  Future<void> writeMultiple(List<SecureStorageItem> items) async {
    for (var item in items) {
      // if (item.value is bool) {
      //   await writeBool(SecureStorageItem(key: item.key, value: item.value));
      // } else {
      await write(item);
      // }
    }
  }

  @override
  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<bool?> readBool(String key) async {
    return _prefs.getBool(key);
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    await _prefs.clear();
  }

  @override
  Future<bool> exists(String key) async {
    return _prefs.containsKey(key);
  }

  @override
  Future<Map<String, String>> readAll() async {
    return _prefs.getKeys().fold<Map<String, String>>({},
        (Map<String, String> map, String key) {
      map[key] = _prefs.getString(key)!;
      return map;
    });
  }

  @override
  Future<bool> containsKey(String key) async {
    return _prefs.containsKey(key);
  }
}
