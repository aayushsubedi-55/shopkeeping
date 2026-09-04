import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shopnepal/common/http/http.dart';
import 'package:shopnepal/common/logger/logger.dart';
import 'package:shopnepal/common/storage/secure_storage.dart';
import 'package:shopnepal/common/utils/utils.dart';
import 'package:shopnepal/features/auth/model/user_model.dart';
import 'package:shopnepal/features/auth/resource/auth_api_provider.dart';

/// Holds the staff session: the access token, the signed-in user, and the
/// operations that change either.
///
/// Staff accounts are created by the owner — there is no self-signup, OTP or
/// social login. Login is email-or-phone plus password.
class AuthRepository {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  late AuthApiProvider authApiProvider;
  late DeviceInfoUtils deviceInfoUtils;

  AuthRepository({required this.apiProvider, required this.secureStorage}) {
    authApiProvider = AuthApiProvider(apiProvider: apiProvider);
    deviceInfoUtils = DeviceInfoUtils();
  }

  String _accessToken = '';
  String _refreshToken = '';

  String get accessToken => _accessToken;
  String get refreshToken => _refreshToken;

  bool get isAuthenticated => _accessToken.isNotEmpty && _user.value != null;

  final ValueNotifier<bool> _isLoggedIn = ValueNotifier(false);
  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;

  final ValueNotifier<UserModel?> _user = ValueNotifier(null);
  ValueNotifier<UserModel?> get user => _user;

  String get userId => _user.value?.id ?? '';

  // ── Session lifecycle ───────────────────────────────────────────────────

  Future<void> initial() async => _loadSessionFromStorage();

  Future<void> _loadSessionFromStorage() async {
    final token = await secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      _accessToken = token;
      _isLoggedIn.value = true;
    } else {
      _accessToken = '';
      _isLoggedIn.value = false;
    }
    _user.value = await secureStorage.getUser();
  }

  /// Clears in-memory auth state without touching secure storage.
  void clearInMemorySession() {
    _accessToken = '';
    _refreshToken = '';
    _isLoggedIn.value = false;
    _user.value = null;
  }

  /// Clears auth from both storage and memory.
  Future<void> clearAuthSession() async {
    await secureStorage.clearAuthSession();
    clearInMemorySession();
  }

  Future<void> setAccessToken(String token) async {
    try {
      await secureStorage.saveAccessToken(token);
      _accessToken = token;
      _isLoggedIn.value = true;
    } catch (e) {
      Log.e(e);
    }
  }

  Future<void> setRefreshToken(String token) async {
    try {
      await secureStorage.saveRefreshToken(token);
      _refreshToken = token;
    } catch (e) {
      Log.e(e);
    }
  }

  Future<String?> tryLoadAccessToken() async {
    try {
      final token = await secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        _accessToken = token;
        _isLoggedIn.value = true;
        return token;
      }
    } catch (e) {
      Log.e(e);
    }
    _accessToken = '';
    _isLoggedIn.value = false;
    return null;
  }

  void setUser(UserModel user) => _user.value = user;

  Future<Map<String, dynamic>> _buildDevicePayload() async {
    return {
      'deviceId': await deviceInfoUtils.getStableDeviceId(),
      'platform': Platform.isIOS ? 'ios' : 'android',
      'appVersion': await deviceInfoUtils.getAppVersion(),
    };
  }

  // ── Operations ──────────────────────────────────────────────────────────

  /// Email-or-phone + password login. On success the session is persisted.
  Future<DataResponse<bool>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final res = await authApiProvider.login(
        body: {
          'emailOrPhone': emailOrPhone,
          'password': password,
          'device': await _buildDevicePayload(),
        },
      );

      final data = res['data']?['data'];
      if (data is! Map) {
        return DataResponse.error('Invalid payload in login response');
      }

      final user = UserModel.fromMap(Map<String, dynamic>.from(data));
      if (user.accessToken.isEmpty) {
        return DataResponse.error('Access token not found in login response');
      }

      await setAccessToken(user.accessToken);
      await secureStorage.setUser(user: user);
      _user.value = user;
      _isLoggedIn.value = true;

      return DataResponse.success(true);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<UserModel>> getMe() async {
    if (!isAuthenticated) {
      return DataResponse.error('User not authenticated');
    }

    try {
      final res = await authApiProvider.getMe();

      final rawUser = res['data']?['data'] ?? res['data'];
      if (rawUser is! Map) {
        return DataResponse.error('Invalid user payload in /auth/me response');
      }

      final fetched = UserModel.fromMap(Map<String, dynamic>.from(rawUser));
      final current = _user.value;
      final merged = fetched.copyWith(
        accessToken: (current?.accessToken.isNotEmpty ?? false)
            ? current!.accessToken
            : _accessToken,
      );

      _user.value = merged;
      await secureStorage.setUser(user: merged);

      return DataResponse.success(merged);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  Future<DataResponse<bool>> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await authApiProvider.changePassword(
        body: {
          'newPassword': newPassword,
          if (currentPassword != null && currentPassword.isNotEmpty)
            'currentPassword': currentPassword,
        },
      );

      // The backend may rotate tokens on a password change.
      final data = res['data']?['data'];
      if (data is Map) {
        final payload = Map<String, dynamic>.from(data);
        final newAccess = payload['accessToken']?.toString() ?? '';
        final newRefresh = payload['refreshToken']?.toString() ?? '';

        if (newAccess.isNotEmpty) {
          await setAccessToken(newAccess);
          final currentUser = _user.value;
          if (currentUser != null) {
            final updated = currentUser.copyWith(accessToken: newAccess);
            _user.value = updated;
            await secureStorage.setUser(user: updated);
          }
        }
        if (newRefresh.isNotEmpty) await setRefreshToken(newRefresh);
      }

      return DataResponse.success(true);
    } on CustomException catch (e) {
      Log.e(e);
      return DataResponse.error(
        e.message?.toString() ?? e.toString(),
        e.statusCode,
        e.code,
      );
    } catch (e) {
      Log.e(e);
      return DataResponse.error(e.toString());
    }
  }

  /// Always succeeds locally: a failed server call must not strand someone in a
  /// signed-in state they cannot leave.
  Future<DataResponse> logout() async {
    try {
      await secureStorage.removeUser();
      await secureStorage.deleteAccessToken();
    } catch (e) {
      Log.e(e);
    }
    clearInMemorySession();
    return DataResponse.success(true);
  }
}
