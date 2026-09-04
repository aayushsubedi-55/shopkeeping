import 'dart:convert';

/// JWT token utilities
class JwtUtils {
  /// Parse JWT payload
  Map<String, dynamic> parseJwtPayLoad(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw const FormatException('Invalid token');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);

      if (payloadMap is! Map<String, dynamic>) {
        throw const FormatException('Invalid payload');
      }

      return payloadMap;
    } catch (e) {
      throw FormatException('Error parsing JWT: $e');
    }
  }

  /// Decode base64
  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw const FormatException('Illegal base64url string');
    }

    return utf8.decode(base64Url.decode(output));
  }

  /// Check if token is expired
  bool isTokenExpired(String token) {
    try {
      final payload = parseJwtPayLoad(token);
      if (payload['exp'] == null) return true;

      final expiryDate = DateTime.fromMillisecondsSinceEpoch(
        payload['exp'] * 1000,
      );

      return DateTime.now().isAfter(expiryDate);
    } catch (e) {
      return true;
    }
  }

  /// Get token expiry date
  DateTime? getTokenExpiryDate(String token) {
    try {
      final payload = parseJwtPayLoad(token);
      if (payload['exp'] == null) return null;

      return DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
    } catch (e) {
      return null;
    }
  }
}
