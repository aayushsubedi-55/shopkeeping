import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopnepal/core/config/app_config.dart';
import 'package:shopnepal/core/network/api_provider.dart';
import 'package:shopnepal/core/storage/storage.dart';
import 'package:shopnepal/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shopnepal/features/auth/domain/repositories/auth_repository.dart';
import 'package:shopnepal/features/media/data/repositories/media_repository_impl.dart';
import 'package:shopnepal/features/media/domain/repositories/media_repository.dart';
import 'package:shopnepal/features/supplier/data/repositories/supplier_repository_impl.dart';
import 'package:shopnepal/features/supplier/domain/repositories/supplier_repository.dart';

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
          create: (context) => AuthRepositoryImpl(
            apiProvider: RepositoryProvider.of<ApiProvider>(context),
            secureStorage: RepositoryProvider.of<SecureStorage>(context),
          ),
          lazy: true,
        ),

        RepositoryProvider<MediaRepository>(
          create: (context) => MediaRepositoryImpl(
            apiProvider: RepositoryProvider.of<ApiProvider>(context),
          ),
          lazy: true,
        ),

        RepositoryProvider<SupplierRepository>(
          create: (context) => SupplierRepositoryImpl(
            apiProvider: RepositoryProvider.of<ApiProvider>(context),
          ),
          lazy: true,
        ),
      ],
      child: child,
    );
  }
}
