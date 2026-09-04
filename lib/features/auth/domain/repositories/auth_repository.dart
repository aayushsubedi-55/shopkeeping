import 'package:flutter/foundation.dart';
import 'package:shopnepal/core/network/http.dart';
import 'package:shopnepal/features/auth/domain/entities/user.dart';

/// Holds the staff session: the access token, the signed-in user, and the
/// operations that change either.
///
/// Staff accounts are created by the owner — there is no self-signup, OTP or
/// social login. Login is email-or-phone plus password.
///
/// Session state is exposed as [ValueNotifier] (rather than a stream) so
/// widgets such as `UserListener` can rebuild on change without a cubit of
/// their own — this is a stateful session store, not a stateless CRUD
/// resource, so it keeps `package:flutter/foundation.dart` in its contract.
abstract class AuthRepository {
  bool get isAuthenticated;

  ValueNotifier<bool> get isLoggedIn;
  ValueNotifier<User?> get user;

  /// Restores any cached session from storage.
  Future<void> initial();

  /// Clears auth from both storage and memory.
  Future<void> clearAuthSession();

  /// Email-or-phone + password login. On success the session is persisted.
  Future<DataResponse<bool>> login({
    required String emailOrPhone,
    required String password,
  });

  Future<DataResponse<User>> getMe();

  Future<DataResponse<bool>> changePassword({
    String? currentPassword,
    required String newPassword,
  });

  /// Always succeeds locally: a failed server call must not strand someone in
  /// a signed-in state they cannot leave.
  Future<DataResponse> logout();
}
