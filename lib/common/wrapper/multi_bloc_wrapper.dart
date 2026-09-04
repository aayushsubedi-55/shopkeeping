import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/features/auth/bloc/get_me_cubit.dart';
import 'package:shopnepal/features/auth/bloc/logout_cubit.dart';
import 'package:shopnepal/features/auth/resource/auth_repository.dart';

/// App-wide cubits. Feature-scoped cubits are provided at their own route,
/// not here — only genuinely global session state belongs in this list.
class MultiBlocWrapper extends StatelessWidget {
  final Widget child;

  const MultiBlocWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetMeCubit(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => LogoutCubit(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
          ),
          lazy: true,
        ),
      ],
      child: child,
    );
  }
}
