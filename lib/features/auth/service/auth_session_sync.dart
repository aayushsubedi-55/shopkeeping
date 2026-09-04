import 'package:shopnepal/features/auth/resource/auth_repository.dart';

/// Global access to [AuthRepository] for layers that cannot use BuildContext
/// (e.g. Dio interceptors).
class AuthSessionSync {
  AuthSessionSync._();

  static AuthRepository? _authRepository;

  static void configure({required AuthRepository authRepository}) {
    _authRepository = authRepository;
  }

  static AuthRepository? get repository => _authRepository;

  static bool get isAuthenticated =>
      _authRepository?.isAuthenticated ?? false;

  static Future<void> clearSession() async {
    await _authRepository?.clearAuthSession();
  }
}
