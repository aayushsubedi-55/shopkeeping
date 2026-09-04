import 'package:flutter/material.dart';
import 'package:shopnepal/common/wrapper/multi_bloc_wrapper.dart';
import 'package:shopnepal/common/wrapper/multi_repository_wrapper.dart';
import 'common/config/config.dart';
import 'common/theme/theme.dart';
import 'common/utils/toast_message_utils.dart';
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
