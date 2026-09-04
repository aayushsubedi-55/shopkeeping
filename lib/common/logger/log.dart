import 'package:logger/logger.dart';
import 'package:shopnepal/common/config/app_config.dart';

class Log {
  static Logger log = Logger();

  static void i(dynamic data) {
    if (AppConfig.enableDetailedLogging) log.i(data);
  }

  static void e(dynamic data) {
    if (AppConfig.enableDetailedLogging) log.e(data);
  }

  static void d(dynamic data) {
    if (AppConfig.enableDetailedLogging) log.d(data);
  }

  static void w(dynamic data) {
    if (AppConfig.enableDetailedLogging) log.w(data);
  }
}
