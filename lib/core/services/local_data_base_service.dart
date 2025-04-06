
abstract class LocalDataBaseService {

  Future<bool> setData({required String key, required Map<String, dynamic> value});

  Future<bool> setBool({required String key, required bool value});

  Future<Map<String, dynamic>?> getData({required String key});

  Future<bool?> getBool({required String key});
  
  Future<bool> removeLocalData({required String key});
}
