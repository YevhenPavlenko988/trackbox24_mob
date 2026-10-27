import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Keychain / Keystore backed key-value store for the JWT and the base URL override.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _token = 'tb24.token';
  static const _tokenExpiresAt = 'tb24.tokenExpiresAt';
  static const _baseUrl = 'tb24.baseUrl';
  static const _printerId = 'tb24.printer.id';
  static const _printerName = 'tb24.printer.name';
  static const _printerDensity = 'tb24.printer.density';
  static const _printerRoll = 'tb24.printer.roll';
  static const _printerOffset = 'tb24.printer.offset';

  Future<String?> readToken() => _storage.read(key: _token);

  Future<DateTime?> readTokenExpiresAt() async {
    final raw = await _storage.read(key: _tokenExpiresAt);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  Future<void> writeToken(String token, {required DateTime expiresAt}) async {
    await _storage.write(key: _token, value: token);
    await _storage.write(
      key: _tokenExpiresAt,
      value: expiresAt.toIso8601String(),
    );
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _token);
    await _storage.delete(key: _tokenExpiresAt);
  }

  Future<String?> readBaseUrl() => _storage.read(key: _baseUrl);

  Future<void> writeBaseUrl(String? url) => url == null || url.isEmpty
      ? _storage.delete(key: _baseUrl)
      : _storage.write(key: _baseUrl, value: url);

  /// The label printer picked in the settings: its Bluetooth id and the name it was shown with.
  Future<(String id, String name)?> readPrinter() async {
    final id = await _storage.read(key: _printerId);
    if (id == null || id.isEmpty) return null;
    return (id, await _storage.read(key: _printerName) ?? '');
  }

  Future<void> writePrinter(String? id, String? name) async {
    if (id == null) {
      await _storage.delete(key: _printerId);
      await _storage.delete(key: _printerName);
      return;
    }
    await _storage.write(key: _printerId, value: id);
    await _storage.write(key: _printerName, value: name ?? '');
  }

  Future<int?> readPrinterDensity() async {
    final raw = await _storage.read(key: _printerDensity);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> writePrinterDensity(int value) =>
      _storage.write(key: _printerDensity, value: '$value');

  /// Roll width in mm; null until chosen.
  Future<int?> readPrinterRoll() async {
    final raw = await _storage.read(key: _printerRoll);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> writePrinterRoll(int mm) =>
      _storage.write(key: _printerRoll, value: '$mm');

  /// Sideways shift of the print in mm; null until set.
  Future<int?> readPrinterOffset() async {
    final raw = await _storage.read(key: _printerOffset);
    return raw == null ? null : int.tryParse(raw);
  }

  Future<void> writePrinterOffset(int mm) =>
      _storage.write(key: _printerOffset, value: '$mm');
}
