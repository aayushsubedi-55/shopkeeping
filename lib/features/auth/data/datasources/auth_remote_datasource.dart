import 'package:shopnepal/core/network/http.dart';

class AuthRemoteDataSource {
  final ApiProvider apiProvider;

  final String basePath = "auth";

  AuthRemoteDataSource({required this.apiProvider});

  /// Email-or-phone + password. Staff accounts are created by the owner, so
  /// there is no register, OTP or password-reset endpoint.
  Future<dynamic> login({required Map<String, dynamic> body}) async {
    return await apiProvider.post('$basePath/login', body);
  }

  Future<dynamic> getMe() async {
    return await apiProvider.get('$basePath/me');
  }

  Future<dynamic> changePassword({required Map<String, dynamic> body}) async {
    return await apiProvider.post('$basePath/me/change-password', body);
  }
}
