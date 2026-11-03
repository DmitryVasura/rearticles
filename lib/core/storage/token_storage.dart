import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';

  final FlutterSecureStorage storage;

  const TokenStorage(this.storage);

  Future<void> saveToken(String token) {
    return storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() {
    return storage.read(
      key: _tokenKey,
    );
  }

  Future<void> saveUserId(int userId) {
    return storage.write(
      key: _userIdKey,
      value: userId.toString(),
    );
  }

  Future<int?> getUserId() async {
    final value = await storage.read(
      key: _userIdKey,
    );

    return value == null ? null : int.tryParse(value);
  }

  Future<void> deleteToken() async {
    await storage.delete(key: _tokenKey);
    await storage.delete(key: _userIdKey);
  }
}