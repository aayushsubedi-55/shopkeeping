import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shopnepal/core/logger/logger.dart';
import 'package:shopnepal/core/storage/secure_storage.dart';

// this page is package dependent
// device_info_plus
// package_info_plus

class DeviceInfoUtils {
  final SecureStorage _secureStorage = SecureStorage();

  Future<int?> getSdkVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;
    return info.version.sdkInt;
  }

  Future<String> getDeviceId() async {
    try {
      var deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        // import 'dart:io'
        var iosDeviceInfo = await deviceInfo.iosInfo;
        return iosDeviceInfo.identifierForVendor ?? ""; // unique ID on iOS
      } else if (Platform.isAndroid) {
        var androidDeviceInfo = await deviceInfo.androidInfo;
        return androidDeviceInfo.id; // unique ID on Android
      } else {
        return "";
      }
    } catch (e) {
      Log.e(e);

      return "";
    }
  }

  /// Stable UUID per app install, persisted in secure storage.
  Future<String> getStableDeviceId() async {
    final existing = await _secureStorage.getStableDeviceId();
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final deviceId = _generateUuidV4();
    await _secureStorage.saveStableDeviceId(deviceId);
    return deviceId;
  }

  String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;

    String hex(int value) => value.toRadixString(16).padLeft(2, '0');

    return '${hex(bytes[0])}${hex(bytes[1])}${hex(bytes[2])}${hex(bytes[3])}-'
        '${hex(bytes[4])}${hex(bytes[5])}-'
        '${hex(bytes[6])}${hex(bytes[7])}-'
        '${hex(bytes[8])}${hex(bytes[9])}-'
        '${hex(bytes[10])}${hex(bytes[11])}${hex(bytes[12])}${hex(bytes[13])}${hex(bytes[14])}${hex(bytes[15])}';
  }

  Future<String> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      Log.i(packageInfo.version);
      Log.i(packageInfo.buildNumber);
      return packageInfo.version;
    } catch (e) {
      if (kDebugMode) {
        Log.e(e);
      }

      return "";
    }
  }

  // static Future<bool> isAppUpdate() async {
  //   final currentVersion = await getAppVersion();

  //   final oldVersion = await AuthHive().getAppVersion();

  //   if (oldVersion == currentVersion) {
  //     return false;
  //   }
  //   return true;
  // }

  // static Future<void> setAppVersion() async {
  //   final currentVersion = await getAppVersion();

  //   await AuthHive().setAppVersion(currentVersion);
  // }
}
