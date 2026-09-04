import 'package:shopnepal/common/constants/app_strings.dart';

// all form validator methods
class FormValidator {
  static String digitsOnly(String? value) {
    return (value ?? '').replaceAll(RegExp(r'[^0-9]'), '').trim();
  }

  static String? fullName(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return 'Please enter your full name';
    final parts = trimmed
        .split(RegExp(r'\s+'))
        .where((p) => p.trim().isNotEmpty)
        .toList();
    if (parts.length < 2) return 'Please enter first and last name';
    return null;
  }

  static String? emailOptional(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(trimmed) ? null : 'Enter a valid email address';
  }

  static String? emailRequired(String? value) {
    final trimmed = (value ?? '').trim();
    if (trimmed.isEmpty) return null;
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return regex.hasMatch(trimmed) ? null : 'Enter a valid email address';
  }

  static const int passwordMinLength = 8;

  static String? password(String? value, {int minLength = passwordMinLength}) {
    final value0 = value ?? '';
    if (value0.isEmpty) return 'Please enter a password';
    if (value0.length < minLength) {
      return 'Password must be at least $minLength characters';
    }
    if (!RegExp(r'[a-z]').hasMatch(value0)) {
      return 'Password must include a lowercase letter';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value0)) {
      return 'Password must include an uppercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value0)) {
      return 'Password must include a number';
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value0)) {
      return 'Password must include a special character';
    }
    return null;
  }

  static String? confirmPassword(String? value, String? original) {
    final value0 = value ?? '';
    if (value0.isEmpty) return 'Please confirm your password';
    if (value0 != (original ?? '')) return 'Passwords do not match';
    return null;
  }

  static String? phoneNumber(
    String? value, {
    int minLength = 7,
    int maxLength = 15,
  }) {
    final digits = digitsOnly(value);

    if (digits.isEmpty) return AppStrings.pleaseEnterYourPhoneNumber;
    if (digits.length < minLength) return 'Enter a valid phone number';
    if (digits.length > maxLength) return 'Enter a valid phone number';
    return null;
  }
}
