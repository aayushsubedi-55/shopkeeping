# AppNavigator - Complete Method Reference

## 📋 Table of Contents
- [Basic Navigation](#basic-navigation)
- [Pop Navigation](#pop-navigation)
- [Named Routes](#named-routes)
- [Imperative Navigation](#imperative-navigation)
- [Utility Methods](#utility-methods)
- [UI Helpers](#ui-helpers)

---

## Basic Navigation

### `push<T>(PageRouteInfo route)`
Push a new route onto the stack.
```dart
AppNavigator.push(const HomeRoute());
```

### `replace<T>(PageRouteInfo route)`
Replace the current route.
```dart
AppNavigator.replace(const LoginRoute());
```

### `pushAndRemoveUntil<T>(PageRouteInfo route, {predicate})`
Push a route and remove routes based on predicate.
```dart
AppNavigator.pushAndRemoveUntil(
  const HomeRoute(),
  predicate: (route) => route.isFirst,
);
```

### `pushAndClearStack<T>(PageRouteInfo route)`
Push a route and clear all previous routes.
```dart
AppNavigator.pushAndClearStack(const HomeRoute());
```

---

## Pop Navigation

### `pop<T>([result])`
Safely pop the current route (checks if can pop).
```dart
AppNavigator.pop();
AppNavigator.pop<String>('result_data');
```

### `forcePop<T>([result])`
Force pop without checking if can pop.
```dart
AppNavigator.forcePop();
```

### `popUntil(predicate)`
Pop routes until predicate returns true.
```dart
AppNavigator.popUntil((route) => route.settings.name == 'HomeRoute');
```

### `popUntilRoute(String routeName)`
Pop until a specific route name.
```dart
AppNavigator.popUntilRoute('HomeRoute');
```

### `popUntilRoot()`
Pop all routes until the root route.
```dart
AppNavigator.popUntilRoot();
```

### `popUntilFirst()`
Pop until the first page in the stack.
```dart
AppNavigator.popUntilFirst();
```

### `popUntilCheckRoute({routeName, optionalRouteName})`
Pop until one of the specified route names.
```dart
AppNavigator.popUntilCheckRoute(
  routeName: 'HomeRoute',
  optionalRouteName: 'LoginRoute',
);
```

### `canPop()`
Check if the current route can be popped.
```dart
if (AppNavigator.canPop()) {
  AppNavigator.pop();
}
```

### `removeRoute(PageRouteInfo route)`
Remove a specific route from the stack.
```dart
AppNavigator.removeRoute(const SettingsRoute());
```

### `removeAllRoutesBelow()`
Remove all routes except the current one.
```dart
AppNavigator.removeAllRoutesBelow();
```

---

## Named Routes

### `toOnboard()`
Navigate to onboard screen (replace).
```dart
AppNavigator.toOnboard();
```

### `toLogin()`
Navigate to login screen (replace).
```dart
AppNavigator.toLogin();
```

### `toHome()`
Navigate to home screen (replace).
```dart
AppNavigator.toHome();
```

### `toLanguageSelection()`
Navigate to language selection screen (push).
```dart
AppNavigator.toLanguageSelection();
```

### `toOnboardPush()`
Navigate to onboard screen (push).
```dart
AppNavigator.toOnboardPush();
```

### `toOtpVerification({phoneNumber})`
Navigate to OTP verification page.
```dart
AppNavigator.toOtpVerification(phoneNumber: '+1234567890');
```

### `toSignup()`
Navigate to signup page (replace).
```dart
AppNavigator.toSignup();
```

### `toLoginPage()`
Navigate to login page (replace).
```dart
AppNavigator.toLoginPage();
```

---

## Imperative Navigation

### `pushPage<T>(Widget page)`
Push any widget as a page.
```dart
AppNavigator.pushPage(MyCustomPage());
```

### `replacePage<T>(Widget page)`
Replace current page with any widget.
```dart
AppNavigator.replacePage(MyCustomPage());
```

### `pushPageAndClearStack<T>(Widget page)`
Push a page and clear all previous routes.
```dart
AppNavigator.pushPageAndClearStack(MyCustomPage());
```

### `pushPageAndRemoveUntil<T>(Widget page, {predicate})`
Push a page and remove routes based on predicate.
```dart
AppNavigator.pushPageAndRemoveUntil(
  MyCustomPage(),
  predicate: (route) => route.isFirst,
);
```

### `pushCustomRoute<T>(Route<T> route)`
Push a custom route (for animations, transitions).
```dart
AppNavigator.pushCustomRoute(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
);
```

### `replaceCustomRoute<T>(Route<T> route)`
Replace with a custom route.
```dart
AppNavigator.replaceCustomRoute(myCustomRoute);
```

---

## Utility Methods

### `context`
Get the current BuildContext.
```dart
BuildContext ctx = AppNavigator.context;
```

### `navigationKey`
Get the navigator key.
```dart
GlobalKey<NavigatorState> key = AppNavigator.navigationKey;
```

### `currentRouteName`
Get the current route name.
```dart
String? name = AppNavigator.currentRouteName;
```

### `currentRoutePath`
Get the current route path.
```dart
String? path = AppNavigator.currentRoutePath;
```

### `isRouteActive(String routeName)`
Check if a specific route is currently active.
```dart
bool isHome = AppNavigator.isRouteActive('HomeRoute');
```

### `routeStack`
Get the current route stack.
```dart
List<AutoRoutePage> stack = AppNavigator.routeStack;
```

---

## UI Helpers

### `showBottomSheet<T>({builder, ...})`
Show a modal bottom sheet.
```dart
AppNavigator.showBottomSheet(
  builder: (context) => MyBottomSheet(),
  isDismissible: true,
  enableDrag: true,
  backgroundColor: Colors.white,
);
```

### `showDialogBox<T>({builder, ...})`
Show a dialog.
```dart
AppNavigator.showDialogBox(
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Content'),
  ),
  barrierDismissible: true,
);
```

### `showSnackBar({message, ...})`
Show a snackbar.
```dart
AppNavigator.showSnackBar(
  message: 'Success!',
  duration: Duration(seconds: 3),
  backgroundColor: Colors.green,
  action: SnackBarAction(
    label: 'Undo',
    onPressed: () {},
  ),
);
```

### `hideSnackBar()`
Hide the current snackbar.
```dart
AppNavigator.hideSnackBar();
```

---

## Summary

**Total Methods: 35+**

- ✅ **Basic Navigation**: 4 methods
- ✅ **Pop Navigation**: 10 methods
- ✅ **Named Routes**: 8 methods
- ✅ **Imperative Navigation**: 6 methods
- ✅ **Utility Methods**: 6 methods
- ✅ **UI Helpers**: 4 methods

All navigation is centralized, type-safe, and doesn't require BuildContext!
