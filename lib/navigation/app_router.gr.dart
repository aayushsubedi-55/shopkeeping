// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ChangePasswordScreen]
class ChangePasswordRoute extends PageRouteInfo<void> {
  const ChangePasswordRoute({List<PageRouteInfo>? children})
    : super(ChangePasswordRoute.name, initialChildren: children);

  static const String name = 'ChangePasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChangePasswordScreen();
    },
  );
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [ExtractionScreen]
class ExtractionRoute extends PageRouteInfo<void> {
  const ExtractionRoute({List<PageRouteInfo>? children})
    : super(ExtractionRoute.name, initialChildren: children);

  static const String name = 'ExtractionRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExtractionScreen();
    },
  );
}

/// generated route for
/// [ImportOrderLinesScreen]
class ImportOrderLinesRoute extends PageRouteInfo<ImportOrderLinesRouteArgs> {
  ImportOrderLinesRoute({
    Key? key,
    required String orderId,
    List<PageRouteInfo>? children,
  }) : super(
         ImportOrderLinesRoute.name,
         args: ImportOrderLinesRouteArgs(key: key, orderId: orderId),
         rawPathParams: {'orderId': orderId},
         initialChildren: children,
       );

  static const String name = 'ImportOrderLinesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<ImportOrderLinesRouteArgs>(
        orElse: () =>
            ImportOrderLinesRouteArgs(orderId: pathParams.getString('orderId')),
      );
      return ImportOrderLinesScreen(key: args.key, orderId: args.orderId);
    },
  );
}

class ImportOrderLinesRouteArgs {
  const ImportOrderLinesRouteArgs({this.key, required this.orderId});

  final Key? key;

  final String orderId;

  @override
  String toString() {
    return 'ImportOrderLinesRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ImportOrderLinesRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [ImportOrderScreen]
class ImportOrderRoute extends PageRouteInfo<void> {
  const ImportOrderRoute({List<PageRouteInfo>? children})
    : super(ImportOrderRoute.name, initialChildren: children);

  static const String name = 'ImportOrderRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImportOrderScreen();
    },
  );
}

/// generated route for
/// [LandedCostScreen]
class LandedCostRoute extends PageRouteInfo<LandedCostRouteArgs> {
  LandedCostRoute({Key? key, String? orderId, List<PageRouteInfo>? children})
    : super(
        LandedCostRoute.name,
        args: LandedCostRouteArgs(key: key, orderId: orderId),
        initialChildren: children,
      );

  static const String name = 'LandedCostRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LandedCostRouteArgs>(
        orElse: () => const LandedCostRouteArgs(),
      );
      return LandedCostScreen(key: args.key, orderId: args.orderId);
    },
  );
}

class LandedCostRouteArgs {
  const LandedCostRouteArgs({this.key, this.orderId});

  final Key? key;

  final String? orderId;

  @override
  String toString() {
    return 'LandedCostRouteArgs{key: $key, orderId: $orderId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LandedCostRouteArgs) return false;
    return key == other.key && orderId == other.orderId;
  }

  @override
  int get hashCode => key.hashCode ^ orderId.hashCode;
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [ProductScreen]
class ProductRoute extends PageRouteInfo<void> {
  const ProductRoute({List<PageRouteInfo>? children})
    : super(ProductRoute.name, initialChildren: children);

  static const String name = 'ProductRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProductScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [SplashScreen]
class SplashRoute extends PageRouteInfo<void> {
  const SplashRoute({List<PageRouteInfo>? children})
    : super(SplashRoute.name, initialChildren: children);

  static const String name = 'SplashRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SplashScreen();
    },
  );
}

/// generated route for
/// [StockScreen]
class StockRoute extends PageRouteInfo<void> {
  const StockRoute({List<PageRouteInfo>? children})
    : super(StockRoute.name, initialChildren: children);

  static const String name = 'StockRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StockScreen();
    },
  );
}

/// generated route for
/// [SupplierScreen]
class SupplierRoute extends PageRouteInfo<void> {
  const SupplierRoute({List<PageRouteInfo>? children})
    : super(SupplierRoute.name, initialChildren: children);

  static const String name = 'SupplierRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SupplierScreen();
    },
  );
}
