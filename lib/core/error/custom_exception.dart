import 'package:shopnepal/core/constants/api_constant.dart';

/// Base custom exception
class CustomException implements Exception {
  CustomException([this._message, this._prefix, this.statusCode, this.code]);

  final dynamic _message;
  final dynamic _prefix;
  final int? statusCode;
  final String? code;

  dynamic get message => _message;

  @override
  String toString() {
    return "${_prefix ?? ""}$_message";
  }
}

/// Fetch data exception
class FetchDataException extends CustomException {
  FetchDataException([String? message, int? statusCode])
    : super(message, "${ApiConstant.errorDuringCommunication}: ", statusCode);
}

/// No internet exception
class NoInternetException extends CustomException {
  NoInternetException([String? message, int? statusCode])
    : super(
        message ?? ApiConstant.noInternetConnection,
        "",
        statusCode ?? ApiConstant.statusNoInternet,
      );
}

/// Bad request exception
class BadRequestException extends CustomException {
  BadRequestException([String? message, int? statusCode, String? code])
    : super(
        message ?? ApiConstant.badRequest,
        "",
        statusCode ?? ApiConstant.statusBadRequest,
        code,
      );
}

/// Resource not found exception
class ResourceNotFoundException extends CustomException {
  ResourceNotFoundException([String? message, int? statusCode])
    : super(
        message ?? ApiConstant.resourceNotFound,
        "",
        statusCode ?? ApiConstant.statusNotFound,
      );
}

/// Unauthorized exception
class UnauthorisedException extends CustomException {
  UnauthorisedException([String? message, int? statusCode])
    : super(
        message ?? ApiConstant.unauthorized,
        "",
        statusCode ?? ApiConstant.statusUnauthorized,
      );
}

/// Invalid input exception
class InvalidInputException extends CustomException {
  InvalidInputException([String? message, int? statusCode])
    : super(
        message ?? ApiConstant.invalidInput,
        "",
        statusCode ?? ApiConstant.statusBadRequest,
      );
}

/// Internal server error exception
class InternalServerErrorException extends CustomException {
  InternalServerErrorException([String? message, int? statusCode])
    : super(
        message ?? ApiConstant.internalServerError,
        "",
        statusCode ?? ApiConstant.statusInternalServerError,
      );
}

/// Request cancelled exception
class RequestCancelledException extends CustomException {
  RequestCancelledException([String? message])
    : super(message ?? ApiConstant.requestCancelled, "", null);
}

/// Connection timeout exception
class ConnectionTimeoutException extends CustomException {
  ConnectionTimeoutException([String? message])
    : super(message ?? ApiConstant.connectionTimeout, "", null);
}

/// Receive timeout exception
class ReceiveTimeoutException extends CustomException {
  ReceiveTimeoutException([String? message])
    : super(message ?? ApiConstant.receiveTimeout, "", null);
}

/// Send timeout exception
class SendTimeoutException extends CustomException {
  SendTimeoutException([String? message])
    : super(message ?? ApiConstant.sendTimeout, "", null);
}
