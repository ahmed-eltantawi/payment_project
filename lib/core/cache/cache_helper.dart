import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CacheHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  //? ====================================================
  //? ================== Secure Storage ==================
  //? ====================================================

  //! --- save secure data ---
  Future<void> saveSecureData({
    required String key,
    required String value,
  }) async {
    await _storage.write(key: key, value: value);
  }

  //! --- get secure data ---

  Future<String?> getSecureData({required String key}) async {
    return await _storage.read(key: key);
  }

  //! --- delete secure data ---
  Future<void> deleteSecureData({required String key}) async {
    await _storage.delete(key: key);
  }

  //! --- delete all secure data ---
  Future<void> deleteAllSecureData() async {
    await _storage.deleteAll();
  }
}
