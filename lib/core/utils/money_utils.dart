/// Formats currency amounts for display without discarding cents: whole
/// numbers show no decimal places, any other value shows the exact amount
/// to 2 decimal places instead of being rounded off to a whole number.
class MoneyUtils {
  MoneyUtils._();

  static String formatAmount(num value) {
    final doubleValue = value.toDouble();
    return doubleValue == doubleValue.truncateToDouble()
        ? doubleValue.toStringAsFixed(0)
        : doubleValue.toStringAsFixed(2);
  }

  static String format(String currencySymbol, num value) {
    return '$currencySymbol ${formatAmount(value)}';
  }

  /// Format NPR (Nepalese Rupees)
  static String formatNpr(String value) {
    final num parsed = num.tryParse(value) ?? 0;
    return 'Rs. ${formatAmount(parsed)}';
  }

  /// Format CNY (Chinese Yuan)
  static String formatCny(String value) {
    final num parsed = num.tryParse(value) ?? 0;
    return '¥ ${formatAmount(parsed)}';
  }
}
