import 'package:auto_route/auto_route.dart';

import 'package:shopnepal/features/auth/presentation/pages/change_password_screen.dart';
import 'package:shopnepal/features/auth/presentation/pages/login_screen.dart';
import 'package:shopnepal/features/home/presentation/pages/dashboard_screen.dart';
import 'package:shopnepal/features/home/presentation/pages/settings_screen.dart';
import 'package:shopnepal/features/onboard/presentation/pages/splash_screen.dart';
import 'package:shopnepal/features/supplier/presentation/pages/supplier_page.dart';

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
    AutoRoute(page: SupplierRoute.page),
  ];
}
