import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';

class ChangePasswordCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;

  ChangePasswordCubit({required this.authRepository}) : super(CommonInitial());

  Future<void> changePassword({
    String? currentPassword,
    required String newPassword,
  }) async {
    emit(CommonLoading());

    final res = await authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    if (res.status == Status.success) {
      emit(CommonSuccess());
      return;
    }

    emit(CommonError(
      message: res.message ?? 'Unable to change password',
      statusCode: res.statusCode,
      code: res.code,
    ));
  }
}
