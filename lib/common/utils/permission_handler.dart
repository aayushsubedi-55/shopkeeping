import 'dart:async';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static bool _isNotificationAllowedStatus(PermissionStatus status) {
    return status.isGranted || status.isProvisional;
  }

  static Future<bool> isNotificationAllowed() async {
    final status = await Permission.notification.status;
    return _isNotificationAllowedStatus(status);
  }

  static Future<bool> isNotificationPermissionGranted() async {
    return isNotificationAllowed();
  }

  static Future<bool> requestNotificationPermission() async {
    final requestStatus = await Permission.notification.request();
    if (_isNotificationAllowedStatus(requestStatus)) {
      return true;
    }

    await Future<void>.delayed(const Duration(milliseconds: 300));
    final refreshedStatus = await Permission.notification.status;
    return _isNotificationAllowedStatus(refreshedStatus);
  }

  static Future<bool> isNotificationPermanentlyDenied() async {
    final status = await Permission.notification.status;
    return status.isPermanentlyDenied;
  }

  static Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.locationWhenInUse.status;
    return status.isGranted;
  }
}
