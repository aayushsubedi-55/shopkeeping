import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shopnepal/features/auth/data/models/user_model.dart';

/// Encrypted key-value storage for the session and the device identity.
///
/// Anything that is not a credential or a stable device identifier belongs in
/// ordinary preferences, not here.
class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;
  SecureStorage._internal();

  static final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: Platform.isAndroid
        ? const AndroidOptions()
        : AndroidOptions.defaultOptions,
  );

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyStableDeviceId = 'stable_device_id';
  static const String userData = 'userData';

  // ── Access token ────────────────────────────────────────────────────────

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<void> deleteAccessToken() async {
    await _storage.delete(key: _keyAccessToken);
  }

  // ── Refresh token ───────────────────────────────────────────────────────

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> deleteRefreshToken() async {
    await _storage.delete(key: _keyRefreshToken);
  }

  // ── User ────────────────────────────────────────────────────────────────

  Future<void> setUser({required UserModel user}) async {
    await _storage.write(key: userData, value: jsonEncode(user.toMap()));
  }

  Future<UserModel?> getUser() async {
    try {
      final data = await _storage.read(key: userData);
      if (data == null || data.isEmpty) return null;
      return UserModel.fromMap(jsonDecode(data));
    } catch (e) {
      // A corrupt or schema-changed blob must not brick startup — treat it as
      // "no cached user" and let the session be re-fetched.
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> removeUser() async {
    await _storage.delete(key: userData);
  }

  // ── Device identity ─────────────────────────────────────────────────────

  Future<void> saveStableDeviceId(String deviceId) async {
    await _storage.write(key: _keyStableDeviceId, value: deviceId);
  }

  Future<String?> getStableDeviceId() async {
    final value = await _storage.read(key: _keyStableDeviceId);
    if (value == null || value.isEmpty) return null;
    return value;
  }

  // ── Clearing ────────────────────────────────────────────────────────────

  /// Clears credentials and the cached user, keeping the device identity so
  /// the same device is still recognisable after a sign-out.
  Future<void> clearAuthSession() async {
    await deleteAccessToken();
    await deleteRefreshToken();
    await removeUser();
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
