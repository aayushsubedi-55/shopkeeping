import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/common/config/app_config.dart';
import 'package:shopnepal/common/http/api_provider.dart';
import 'package:shopnepal/common/storage/storage.dart';
import 'package:shopnepal/features/auth/resource/auth_repository.dart';
import 'package:shopnepal/features/media/resource/media_repository.dart';

/// Binds shared infrastructure and every feature repository for the app.
///
/// This is the single place an abstract repository is bound to its
/// implementation — nothing in `presentation/` constructs a repository itself.
class MultiRepositoryWrapper extends StatelessWidget {
  final Widget child;
  final Env env;

  const MultiRepositoryWrapper({
    super.key,
    required this.child,
    required this.env,
  });

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Env>(create: (context) => env),

        RepositoryProvider<SecureStorage>(create: (context) => SecureStorage()),

        RepositoryProvider<ApiProvider>(
          create: (context) =>
              ApiProvider(baseUrl: RepositoryProvider.of<Env>(context).baseUrl),
          lazy: true,
        ),

        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
            apiProvider: RepositoryProvider.of<ApiProvider>(context),
            secureStorage: RepositoryProvider.of<SecureStorage>(context),
          ),
          lazy: true,
        ),

        RepositoryProvider<MediaRepository>(
          create: (context) => MediaRepository(
            apiProvider: RepositoryProvider.of<ApiProvider>(context),
          ),
          lazy: true,
        ),
      ],
      child: child,
    );
  }
}
