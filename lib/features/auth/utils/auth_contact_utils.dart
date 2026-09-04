import 'package:shopnepal/common/utils/form_validator.dart';

class AuthContactUtils {
  AuthContactUtils._();

  static String normalizeEmailOrPhone({
    required String value,
    String dialCode = '+977',
  }) {
    final trimmed = value.trim();
    if (trimmed.contains('@')) return trimmed;

    final digits = FormValidator.digitsOnly(trimmed);
    if (digits.isEmpty) return trimmed;
    return '$dialCode$digits';
  }

  static String? resolveEmailOrPhone({
    required String phoneValue,
    required String emailValue,
    String dialCode = '+977',
  }) {
    final email = emailValue.trim();
    if (email.isNotEmpty) {
      if (email.contains('@')) return email;
      return null;
    }

    final phone = normalizeEmailOrPhone(value: phoneValue, dialCode: dialCode);
    if (phone.isEmpty) return null;
    return phone;
  }
}
