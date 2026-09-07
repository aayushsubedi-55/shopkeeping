import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';

/// Password-based login. Reuses the existing verify-login endpoint but sends a
/// `password` payload instead of an OTP, so no OTP verification step is needed.
class LoginCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;

  LoginCubit({required this.authRepository}) : super(CommonInitial());

  Future<void> login({
    required String emailOrPhone,
    required String password,
  }) async {
    emit(CommonLoading());

    final res = await authRepository.login(
      emailOrPhone: emailOrPhone,
      password: password,
    );

    if (res.status == Status.success) {
      emit(CommonSuccess());
    } else {
      emit(CommonError(
        message: res.message ?? '',
        statusCode: res.statusCode,
        code: res.code,
      ));
    }
  }
}
