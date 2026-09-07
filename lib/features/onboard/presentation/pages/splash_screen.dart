import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/cubit/data_state.dart';
import 'package:shopnepal/core/theme/theme.dart';
import 'package:shopnepal/core/widgets/status_bar_wrapper.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopnepal/features/auth/service/auth_session_sync.dart';
import 'package:shopnepal/features/onboard/presentation/cubit/startup_cubit.dart';
import 'package:shopnepal/features/onboard/presentation/widgets/logo_widget.dart';
import 'package:shopnepal/navigation/navigation.dart';

@RoutePage()
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarWrapper(
      isDark: true,
      statusBarColor: ThemeColors.primaryColor,
      child: BlocProvider(
        create: (context) {
          final authRepository = RepositoryProvider.of<AuthRepository>(context);

          // Dio interceptors have no BuildContext, so they reach the session
          // through this static handle. It must be wired before the first
          // authenticated request goes out.
          AuthSessionSync.configure(authRepository: authRepository);

          return StartupCubit(authRepository: authRepository)
            ..checkStartupSession();
        },
        child: BlocListener<StartupCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonStateSuccess<bool>) {
              AppNavigator.completeStartup(isAuthenticated: state.data);
            }
          },
          child: const Scaffold(
            backgroundColor: ThemeColors.primaryColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWidget(isWhite: true),
                  SizedBox(height: 28),
                  SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ThemeColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
