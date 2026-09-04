import 'package:flutter/material.dart';
import 'package:shopnepal/core/wrapper/multi_bloc_wrapper.dart';
import 'package:shopnepal/core/wrapper/multi_repository_wrapper.dart';
import 'core/config/config.dart';
import 'core/theme/theme.dart';
import 'core/utils/toast_message_utils.dart';
import 'navigation/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppConfig.setEnvironment(Environment.dev);
  ThemeManager().loadThemeMode();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    AppNavigator.init(_appRouter.navigatorKey);

    return AnimatedBuilder(
      animation: ThemeManager(),
      builder: (context, child) {
        return MultiRepositoryWrapper(
          env: AppConfig.currentEnv!,
          child: MultiBlocWrapper(
            child: MaterialApp.router(
              title: AppConfig.currentEnv?.appName,
              scaffoldMessengerKey: ToastMessageUtils.messengerKey,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeManager().themeMode,
              routerConfig: _appRouter.config(),
              debugShowCheckedModeBanner: false,
            ),
          ),
        );
      },
    );
  }
}
