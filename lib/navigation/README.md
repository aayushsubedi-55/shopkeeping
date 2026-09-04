# Navigation Module

All navigation logic is centralized in this folder. Pages remain independent of `auto_route` implementation.

## Structure

```
lib/navigation/
├── app_router.dart          # Route definitions (auto_route config)
├── app_router.gr.dart       # Generated routes (auto_route)
├── app_navigator.dart       # Navigation service (all methods)
├── navigation.dart          # Barrel export
└── README.md               # This file
```

## Usage

### Import

```dart
import 'package:shopnepal/navigation/navigation.dart';
```

### Basic Navigation

```dart
// Push a route
AppNavigator.push(const HomeRoute());

// Replace current route
AppNavigator.replace(const LoginRoute());

// Push and remove all previous routes (clear stack)
AppNavigator.pushAndClearStack(const HomeRoute());

// Push and remove until condition
AppNavigator.pushAndRemoveUntil(
  const HomeRoute(),
  predicate: (route) => route.isFirst,
);
```

### Pop Navigation

```dart
// Pop current route (safe - checks if can pop)
AppNavigator.pop();

// Pop with result
AppNavigator.pop<String>('result_data');

// Force pop (doesn't check)
AppNavigator.forcePop();

// Pop until root
AppNavigator.popUntilRoot();

// Pop until first page
AppNavigator.popUntilFirst();

// Pop until specific route name
AppNavigator.popUntilRoute('HomeRoute');

// Pop until route matches condition
AppNavigator.popUntil((route) => route.settings.name == 'HomeRoute');

// Pop with multiple route checks
AppNavigator.popUntilCheckRoute(
  routeName: 'HomeRoute',
  optionalRouteName: 'LoginRoute',
);

// Check if can pop
if (AppNavigator.canPop()) {
  AppNavigator.pop();
}
```

### Named Route Helpers

```dart
// Navigate to specific screens
AppNavigator.toHome();
AppNavigator.toLogin();
AppNavigator.toOnboard();
AppNavigator.toLanguageSelection();
AppNavigator.toOtpVerification(phoneNumber: '+1234567890');
AppNavigator.toSignup();
AppNavigator.toLoginPage();
```

### Imperative Navigation (for pages not in auto_route)

```dart
// Push any widget as a page
AppNavigator.pushPage(MyCustomPage());

// Replace with any widget
AppNavigator.replacePage(MyCustomPage());

// Push and clear stack
AppNavigator.pushPageAndClearStack(MyCustomPage());

// Push and remove until condition
AppNavigator.pushPageAndRemoveUntil(
  MyCustomPage(),
  predicate: (route) => route.isFirst,
);

// Push with custom route (for animations)
AppNavigator.pushCustomRoute(
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => MyPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
);
```

### Utility Methods

```dart
// Get current route info
String? routeName = AppNavigator.currentRouteName;
String? routePath = AppNavigator.currentRoutePath;

// Check if route is active
bool isHome = AppNavigator.isRouteActive('HomeRoute');

// Get route stack
List<AutoRoutePage> stack = AppNavigator.routeStack;

// Remove specific route from stack
AppNavigator.removeRoute(const SettingsRoute());

// Show bottom sheet
AppNavigator.showBottomSheet(
  builder: (context) => MyBottomSheet(),
  isDismissible: true,
  enableDrag: true,
);

// Show dialog
AppNavigator.showDialogBox(
  builder: (context) => AlertDialog(
    title: Text('Title'),
    content: Text('Content'),
  ),
  barrierDismissible: true,
);

// Show snackbar
AppNavigator.showSnackBar(
  message: 'Success!',
  duration: Duration(seconds: 3),
  backgroundColor: Colors.green,
);

// Hide snackbar
AppNavigator.hideSnackBar();
```

### Advanced Usage

```dart
// Navigate from anywhere (BLoC, service, etc.)
class AuthBloc {
  void logout() {
    // No BuildContext needed!
    AppNavigator.pushAndClearStack(const LoginRoute());
  }
}

// Get context for custom operations
BuildContext ctx = AppNavigator.context;

// Access navigator key
GlobalKey<NavigatorState> key = AppNavigator.navigationKey;
```

## Adding New Routes

1. Add screen to `app_router.dart`:
```dart
AutoRoute(page: NewScreenRoute.page),
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Add helper method to `app_navigator.dart`:
```dart
static Future<void> toNewScreen() => push(const NewScreenRoute());
```

## Benefits

- **Single source of truth**: All navigation in one place
- **No BuildContext needed**: Call from anywhere (BLoC, services, etc.)
- **Auto_route independent**: Pages don't import auto_route
- **Type-safe**: Compile-time route checking
- **Easy to test**: Mock navigation service in tests
