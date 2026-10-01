import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keychain / Keystore backed key-value store for the JWT and the base URL override.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage]) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _token = 'tb24.token';
  static const _tokenExpiresAt = 'tb24.tokenExpiresAt';
  static const _baseUrl = 'tb24.baseUrl';

  Future<String?> readToken() => _storage.read(key: _token);

  Future<DateTime?> readTokenExpiresAt() async {
    final raw = await _storage.read(key: _tokenExpiresAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> writeToken(String token, {required DateTime expiresAt}) async {
    await _storage.write(key: _token, value: token);
    await _storage.write(key: _tokenExpiresAt, value: expiresAt.toIso8601String());
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _token);
    await _storage.delete(key: _tokenExpiresAt);
  }

  Future<String?> readBaseUrl() => _storage.read(key: _baseUrl);

  Future<void> writeBaseUrl(String? url) =>
      url == null || url.isEmpty ? _storage.delete(key: _baseUrl) : _storage.write(key: _baseUrl, value: url);
}
