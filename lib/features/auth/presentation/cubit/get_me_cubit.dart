import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/network/data_response.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';

class GetMeCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;

  GetMeCubit({required this.authRepository}) : super(CommonInitial());

  Future<void> fetchMe() async {
    if (!authRepository.isAuthenticated) return;

    if (!isClosed) emit(CommonLoading());

    final res = await authRepository.getMe();

    if (res.status == Status.success) {
      if (!isClosed) emit(CommonSuccess());
      return;
    }

    if (!isClosed) {
      emit(CommonError(message: res.message ?? 'Unable to load profile'));
    }
  }
}
