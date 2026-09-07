import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/core/logger/logger.dart';
import 'package:shopnepal/core/storage/secure_storage.dart';
import 'package:shopnepal/core/utils/utils.dart';
import 'package:shopnepal/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shopnepal/features/auth/data/models/user_model.dart';
import 'package:shopnepal/features/auth/domain/entities/user.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiProvider apiProvider;
  final SecureStorage secureStorage;

  late AuthRemoteDataSource authRemoteDataSource;
  late DeviceInfoUtils deviceInfoUtils;

  AuthRepositoryImpl({required this.apiProvider, required this.secureStorage}) {
    authRemoteDataSource = AuthRemoteDataSource(apiProvider: apiProvider);
    deviceInfoUtils = DeviceInfoUtils();
  }

  String _accessToken = '';

  @override
  bool get isAuthenticated => _accessToken.isNotEmpty && _user.value != null;

  final ValueNotifier<bool> _isLoggedIn = ValueNotifier(false);
  @override
  ValueNotifier<bool> get isLoggedIn => _isLoggedIn;

  final ValueNotifier<User?> _user = ValueNotifier(null);
  @override
  ValueNotifier<User?> get user => _user;

  // ── Session lifecycle ───────────────────────────────────────────────────

  @override
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
  void _clearInMemorySession() {
    _accessToken = '';
    _isLoggedIn.value = false;
    _user.value = null;
  }

  @override
  Future<void> clearAuthSession() async {
    await secureStorage.clearAuthSession();
    _clearInMemorySession();
  }

  Future<void> _setAccessToken(String token) async {
    try {
      await secureStorage.saveAccessToken(token);
      _accessToken = token;
      _isLoggedIn.value = true;
    } catch (e) {
      Log.e(e);
    }
  }

  Future<void> _setRefreshToken(String token) async {
    try {
      await secureStorage.saveRefreshToken(token);
    } catch (e) {
      Log.e(e);
    }
  }

  Future<Map<String, dynamic>> _buildDevicePayload() async {
    return {
      'deviceId': await deviceInfoUtils.getStableDeviceId(),
      'platform': Platform.isIOS ? 'ios' : 'android',
      'appVersion': await deviceInfoUtils.getAppVersion(),
    };
  }

  // ── Operations ──────────────────────────────────────────────────────────

  @override
  Future<DataResponse<bool>> login({
    required String emailOrPhone,
    required String password,
  }) async {
    try {
      final res = await authRemoteDataSource.login(
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

      await _setAccessToken(user.accessToken);
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

  @override
  Future<DataResponse<User>> getMe() async {
    if (!isAuthenticated) {
      return DataResponse.error('User not authenticated');
    }

    try {
      final res = await authRemoteDataSource.getMe();

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

  @override
  Future<DataResponse<bool>> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    try {
      final res = await authRemoteDataSource.changePassword(
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
          await _setAccessToken(newAccess);
          final currentUser = _user.value;
          if (currentUser is UserModel) {
            final updated = currentUser.copyWith(accessToken: newAccess);
            _user.value = updated;
            await secureStorage.setUser(user: updated);
          }
        }
        if (newRefresh.isNotEmpty) await _setRefreshToken(newRefresh);
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

  @override
  Future<DataResponse> logout() async {
    try {
      await secureStorage.removeUser();
      await secureStorage.deleteAccessToken();
    } catch (e) {
      Log.e(e);
    }
    _clearInMemorySession();
    return DataResponse.success(true);
  }
}
