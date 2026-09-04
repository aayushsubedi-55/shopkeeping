import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/features/auth/domain/entities/user.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';

/// Snapshot of the session handed to a [UserListener] builder.
class UserListenerModel {
  final User? userModel;
  final bool isLoggedIn;

  UserListenerModel({this.userModel, required this.isLoggedIn});
}

typedef UserListenableBuilder =
    Widget Function(BuildContext, UserListenerModel);

/// Rebuilds whenever the signed-in user or the logged-in flag changes.
class UserListener extends StatelessWidget {
  const UserListener({super.key, required this.builder});

  final UserListenableBuilder builder;

  @override
  Widget build(BuildContext context) {
    final repo = RepositoryProvider.of<AuthRepository>(context);

    return AnimatedBuilder(
      animation: Listenable.merge([repo.user, repo.isLoggedIn]),
      builder: (context, child) {
        return builder(
          context,
          UserListenerModel(
            isLoggedIn: repo.isLoggedIn.value,
            userModel: repo.user.value,
          ),
        );
      },
    );
  }
}
