import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/common/cubit/data_state.dart';
import 'package:shopnepal/features/auth/resource/auth_repository.dart';

/// Decides where the splash screen sends the user.
///
/// The whole startup policy is: restore any stored session, then go to the
/// dashboard if it is valid, otherwise to login. There is no guest mode, no
/// onboarding carousel and no permission gate to walk through first.
class StartupCubit extends Cubit<CommonState> {
  final AuthRepository authRepository;

  StartupCubit({required this.authRepository}) : super(CommonInitial());

  bool get hasSession => authRepository.isAuthenticated;

  Future<void> checkStartupSession() async {
    emit(CommonLoading());

    try {
      await authRepository.initial();
      emit(CommonStateSuccess<bool>(data: authRepository.isAuthenticated));
    } catch (e) {
      // A broken cached session must not trap the user on the splash screen —
      // fall through to login and let them sign in again.
      emit(const CommonStateSuccess<bool>(data: false));
    }
  }
}
