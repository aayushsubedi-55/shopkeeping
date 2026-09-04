import 'package:auto_route/auto_route.dart';

import 'package:shopnepal/features/auth/ui/page/change_password_screen.dart';
import 'package:shopnepal/features/auth/ui/page/login_screen.dart';
import 'package:shopnepal/features/home/ui/page/dashboard_screen.dart';
import 'package:shopnepal/features/home/ui/page/settings_screen.dart';
import 'package:shopnepal/features/onboard/ui/page/splash_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: DashboardRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: ChangePasswordRoute.page),
  ];
}
