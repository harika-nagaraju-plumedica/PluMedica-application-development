import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  static const _accessTokenKey = 'auth_jwt_token';
  static const _secureStorage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    try {
      await _secureStorage.write(key: _accessTokenKey, value: token);
      return;
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_accessTokenKey, token);
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _secureStorage.read(key: _accessTokenKey);
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {
      // Fallback to shared preferences for unsupported platforms.
    }

    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<void> clearToken() async {
    try {
      await _secureStorage.delete(key: _accessTokenKey);
    } catch (_) {
      // Ignore and clear fallback storage below.
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
  }
}
