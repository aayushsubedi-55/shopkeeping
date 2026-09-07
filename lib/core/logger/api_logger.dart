import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shopnepal/core/config/app_config.dart';
import 'package:shopnepal/core/logger/log.dart';

/// Custom logger for different environments
class ApiLogger {
  static void logRequest(RequestOptions options) {
    if (!AppConfig.enableLogging) return;

    if (AppConfig.enableDetailedLogging) {
      debugPrint('┌─────────────────────────────────────────────────────');
      debugPrint('│ REQUEST');
      debugPrint('├─────────────────────────────────────────────────────');
      debugPrint('│ ${options.method} ${options.uri}');
      debugPrint('│ Headers:');
      options.headers.forEach((key, value) {
        debugPrint('│   $key: $value');
      });
      if (options.data != null) {
        Log.d(options.data);
      }
      debugPrint('└─────────────────────────────────────────────────────');
    } else {
      debugPrint('→ ${options.method} ${options.uri}');
    }
  }

  static void logResponse(Response response) {
    if (!AppConfig.enableLogging) return;

    if (AppConfig.enableDetailedLogging) {
      debugPrint('┌─────────────────────────────────────────────────────');
      debugPrint('│ RESPONSE');
      Log.d(response.statusCode);
      Log.d(response.requestOptions.uri);
      debugPrint('└─────────────────────────────────────────────────────');
      debugPrint('┌─────────────────────────────────────────────────────');
      debugPrint('│ Body:');
      debugPrint('├─────────────────────────────────────────────────────');
      Log.i(response.data);
      debugPrint('└─────────────────────────────────────────────────────');
    } else {
      debugPrint('← ${response.statusCode} ${response.requestOptions.uri}');
    }
  }

  static void logError(DioException error) {
    if (!AppConfig.enableLogging) return;

    debugPrint('┌─────────────────────────────────────────────────────');
    debugPrint('│ ERROR');
    debugPrint('├─────────────────────────────────────────────────────');
    debugPrint('│ ${error.requestOptions.method} ${error.requestOptions.uri}');
    debugPrint('│ Type: ${error.type}');
    debugPrint('│ Message: ${error.message}');
    if (error.response != null) {
      debugPrint('│ Status: ${error.response?.statusCode}');
      if (AppConfig.enableDetailedLogging) {
        Log.e('│ Response: ${error.response?.data}');
      }
    }
    if (AppConfig.enableDetailedLogging) {
      debugPrint('│ Stack trace: ${error.stackTrace}');
    }
    debugPrint('└─────────────────────────────────────────────────────');
  }

  static void log(String message) {
    if (!AppConfig.enableLogging) return;
    debugPrint('ℹ️ $message');
  }
}
