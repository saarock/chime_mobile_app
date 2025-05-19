import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class TokenStorage {
  static final _storage = FlutterSecureStorage();

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'accessToken', value: access);
    await _storage.write(key: 'refreshToken', value: refresh);
  }

  static Future<void> saveUser(UserModel user) async {
    await _storage.write(key: 'user', value: jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final jsonStr = await _storage.read(key: 'user');
    if (jsonStr == null) return null;
    return UserModel.fromJson(jsonDecode(jsonStr));
  }

  static Future<String?> getAccessToken() => _storage.read(key: 'accessToken');
  static Future<String?> getRefreshToken() =>
      _storage.read(key: 'refreshToken');

  static Future<void> clear() async {
    await _storage.deleteAll();
  }
}
