import 'package:flutter/material.dart';

class ToastMessageUtils {
  ToastMessageUtils._();

  /// Wired into MaterialApp.router via `scaffoldMessengerKey` in main.dart.
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void _show(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) {
    final text = message.trim();
    if (text.isEmpty) return;
    final messenger = messengerKey.currentState;
    if (messenger == null) return;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: duration,
        backgroundColor: backgroundColor,
        action: action,
      ),
    );
  }

  static void success(String message) => _show(message);

  static void error(String message) => _show(message);

  static void info(String message) => _show(message);

  static void warning(String message) => _show(message);

  static void show(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    SnackBarAction? action,
  }) => _show(
    message,
    duration: duration,
    backgroundColor: backgroundColor,
    action: action,
  );

  static void dismiss() => messengerKey.currentState?.hideCurrentSnackBar();
}
