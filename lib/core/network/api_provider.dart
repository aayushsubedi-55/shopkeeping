import 'package:dio/dio.dart';
import 'package:shopnepal/core/config/app_config.dart';
import 'package:shopnepal/core/constants/api_constant.dart';
import 'package:shopnepal/core/error/custom_exception.dart';
import 'package:shopnepal/core/network/dio_client.dart';

/// API Provider
/// Separates network layer from repository layer
/// Handles response parsing and error transformation
class ApiProvider {
  final DioClient _dioClient;

  final Env _env = AppConfig.currentEnv!;

  ApiProvider({required String baseUrl})
    : _dioClient = DioClient(baseUrl: baseUrl);

  // ── POST Request ────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> post(
    String path,
    dynamic body, {

    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dioClient.post(
        "${_env.baseUrl}/$path",
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ── GET Request ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dioClient.get(
        "${_env.baseUrl}/$path",
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ── PUT Request ─────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> put(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dioClient.put(
        "${_env.baseUrl}/$path",
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ── PATCH Request ───────────────────────────────────────────────────────

  Future<Map<String, dynamic>> patch(
    String path, {
    dynamic body,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dioClient.patch(
        "${_env.baseUrl}/$path",
        data: body,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ── DELETE Request ──────────────────────────────────────────────────────

  Future<Map<String, dynamic>> delete(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await _dioClient.delete(
        "${_env.baseUrl}/$path",
        data: body,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleDioException(e);
    }
  }

  // ── Response Handler ────────────────────────────────────────────────────

  Map<String, dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;

    // Parse response data
    final dynamic rawData = response.data;
    final Map<String, dynamic> data = rawData is Map
        ? Map<String, dynamic>.from(rawData)
        : (rawData is List)
        ? {"data": rawData}
        : {};

    // Check status code
    if (_isSuccessStatusCode(statusCode)) {
      return {'data': data, 'statusCode': statusCode};
    }

    // Handle error status codes
    throw _createExceptionFromStatusCode(statusCode, data);
  }

  // ── Error Handler ───────────────────────────────────────────────────────

  CustomException _handleDioException(DioException error) {
    // Check for custom exceptions from interceptor
    if (error.error is CustomException) {
      return error.error as CustomException;
    }

    // Handle response errors
    if (error.response != null) {
      final statusCode = error.response!.statusCode ?? 0;
      final dynamic rawData = error.response!.data;
      final Map<String, dynamic> data = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : {};

      return _createExceptionFromStatusCode(statusCode, data);
    }

    // Handle other errors
    return FetchDataException(
      error.message ?? ApiConstant.somethingWentWrong,
      null,
    );
  }

  // ── Helper Methods ──────────────────────────────────────────────────────

  bool _isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  CustomException _createExceptionFromStatusCode(
    int statusCode,
    Map<String, dynamic> data,
  ) {
    final message = _extractErrorMessage(data, statusCode);
    final code = _extractErrorCode(data);

    switch (statusCode) {
      case ApiConstant.statusBadRequest:
        return BadRequestException(message, statusCode, code);

      case ApiConstant.statusUnauthorized:
      case ApiConstant.statusForbidden:
        return UnauthorisedException(message, statusCode);

      case ApiConstant.statusNotFound:
        return ResourceNotFoundException(message, statusCode);

      case ApiConstant.statusConflict:
        return BadRequestException(message, statusCode, code);

      case ApiConstant.statusUnprocessableEntity:
        return InvalidInputException(message, statusCode);

      case ApiConstant.statusTooManyRequests:
        return BadRequestException(
          ApiConstant.tooManyRequests,
          statusCode,
          code,
        );

      case ApiConstant.statusInternalServerError:
        return InternalServerErrorException(message, statusCode);

      default:
        return FetchDataException(message, statusCode);
    }
  }

  String? _extractErrorCode(Map<String, dynamic> data) {
    final code = data['code'];
    if (code is String && code.isNotEmpty) return code;
    if (data['data'] is Map) {
      final nested = data['data']['code'];
      if (nested is String && nested.isNotEmpty) return nested;
    }
    return null;
  }

  String _extractErrorMessage(Map<String, dynamic> data, int statusCode) {
    try {
      // Try different message formats
      if (data['message'] is String && data['message'].toString().isNotEmpty) {
        return data['message'];
      }

      if (data['data'] is Map && data['data']['message'] is String) {
        return data['data']['message'];
      }

      if (data['error'] is String && data['error'].toString().isNotEmpty) {
        return data['error'];
      }

      if (data['message'] is List && (data['message'] as List).isNotEmpty) {
        final messages = data['message'] as List;
        return messages.map((e) => e.toString()).join('\n');
      }

      // Return default message based on status code
      return _getDefaultErrorMessage(statusCode);
    } catch (e) {
      return _getDefaultErrorMessage(statusCode);
    }
  }

  String _getDefaultErrorMessage(int statusCode) {
    switch (statusCode) {
      case ApiConstant.statusBadRequest:
        return ApiConstant.badRequest;
      case ApiConstant.statusUnauthorized:
      case ApiConstant.statusForbidden:
        return ApiConstant.unauthorized;
      case ApiConstant.statusNotFound:
        return ApiConstant.resourceNotFound;
      case ApiConstant.statusUnprocessableEntity:
        return ApiConstant.invalidInput;
      case ApiConstant.statusTooManyRequests:
        return ApiConstant.tooManyRequests;
      case ApiConstant.statusInternalServerError:
        return ApiConstant.internalServerError;
      default:
        return ApiConstant.somethingWentWrong;
    }
  }
}
