import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/common/cubit/data_state.dart';
import 'package:shopnepal/common/http/data_response.dart';
import 'package:shopnepal/features/auth/resource/auth_repository.dart';

class LogoutCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;
  LogoutCubit({required this.authRepository}) : super(CommonInitial());

  void logout() async {
    emit(CommonLoading());
    final res = await authRepository.logout();
    if (res.status == Status.success) {
      emit(CommonSuccess());
    } else {
      emit(CommonError(message: res.message ?? ""));
    }
  }
}
