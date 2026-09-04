import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shopnepal/core/utils/toast_message_utils.dart';
import 'package:shopnepal/navigation/app_router.dart';

/// Central navigation service.
///
/// All navigation goes through here so pages stay independent of auto_route.
class AppNavigator {
  static final AppNavigator _instance = AppNavigator._internal();
  factory AppNavigator() => _instance;
  AppNavigator._internal();

  static GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  static void init(GlobalKey<NavigatorState> navKey) {
    _navigatorKey = navKey;
  }

  static GlobalKey<NavigatorState> get navigationKey => _navigatorKey;

  static BuildContext get context =>
      _navigatorKey.currentState!.overlay!.context;

  // ── Generic navigation ──────────────────────────────────────────────────

  static Future<T?> push<T extends Object?>(PageRouteInfo route) =>
      context.router.push<T>(route);

  static Future<T?> replace<T extends Object?>(PageRouteInfo route) =>
      context.router.replace<T>(route);

  /// Navigate to a route and clear everything below it.
  static Future<T?> pushAndClearStack<T extends Object?>(PageRouteInfo route) =>
      context.router.pushAndPopUntil(route, predicate: (route) => false);

  static Future<bool> pop<T extends Object?>([T? result]) =>
      context.router.maybePop(result);

  static void forcePop<T extends Object?>([T? result]) {
    if (_navigatorKey.currentState?.canPop() ?? false) {
      _navigatorKey.currentState!.pop(result);
    }
  }

  static void popUntilRoute(String routeName) =>
      context.router.popUntil((route) => route.settings.name == routeName);

  static void popUntilRoot() => context.router.popUntilRoot();

  static bool canPop() => context.router.canPop();

  // ── Named destinations ──────────────────────────────────────────────────

  static Future<void> toLogin() => pushAndClearStack(const LoginRoute());

  static Future<void> toDashboard() =>
      pushAndClearStack(const DashboardRoute());

  static Future<void> toSettings() => push(const SettingsRoute());

  static Future<void> toChangePassword() => push(const ChangePasswordRoute());

  static Future<void> toSuppliers() => push(const SupplierRoute());

  /// Ends the splash screen at the right place for the current session.
  static Future<void> completeStartup({required bool isAuthenticated}) =>
      isAuthenticated ? toDashboard() : toLogin();

  // ── Utilities ───────────────────────────────────────────────────────────

  static String? get currentRouteName => context.router.current.name;

  static String? get currentRoutePath => context.router.current.path;

  static bool isRouteActive(String routeName) =>
      context.router.current.name == routeName;

  static Future<T?> showBottomSheet<T>({
    required Widget Function(BuildContext) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? elevation,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
    );
  }

  static Future<T?> showDialogBox<T>({
    required Widget Function(BuildContext) builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
    );
  }

  static void showSnackBar({
    required String message,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) => ToastMessageUtils.show(
    message,
    duration: duration,
    action: action,
    backgroundColor: backgroundColor,
  );

  static void hideSnackBar() => ToastMessageUtils.dismiss();
}
