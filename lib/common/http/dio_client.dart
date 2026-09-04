import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shopnepal/common/config/config.dart';
import 'package:shopnepal/common/constants/api_constant.dart';
import 'package:shopnepal/common/http/http.dart';

import 'package:shopnepal/common/logger/logger.dart';
import 'package:shopnepal/common/storage/secure_storage.dart';
import 'package:shopnepal/common/utils/utils.dart';

import 'package:shopnepal/features/auth/service/auth_session_sync.dart';
import 'package:shopnepal/navigation/navigation.dart';

/// Dio HTTP client
/// Handles all HTTP requests with interceptors for auth, logging, and error handling
class DioClient {
  late final Dio _dio;
  final String baseUrl;

  late JwtUtils jwtUtils;
  late SecureStorage _secureStorage;

  DioClient({required this.baseUrl}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        responseType: ResponseType.json,
        headers: {
          ApiConstant.contentType: ApiConstant.applicationJson,
          ApiConstant.accept: ApiConstant.applicationJson,
        },
      ),
    );

    jwtUtils = JwtUtils();
    _secureStorage = SecureStorage();

    _setupInterceptors();
  }

  /// Setup interceptors
  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  /// Request interceptor
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Add auth token
    final accessToken = await _secureStorage.getAccessToken();
    debugPrint('accessToken: $accessToken');
    if (accessToken != null && accessToken.isNotEmpty) {
      // Check if token is expired
      if (jwtUtils.isTokenExpired(accessToken)) {
        await _handleTokenExpiry(wasAuthenticated: true);
        return handler.reject(
          DioException(
            requestOptions: options,
            error: ApiConstant.sessionTimeout,
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers[ApiConstant.authorization] =
          '${ApiConstant.bearer} $accessToken';
    }

    // Log request
    ApiLogger.logRequest(options);

    handler.next(options);
  }

  /// Response interceptor
  void _onResponse(Response response, ResponseInterceptorHandler handler) {
    ApiLogger.logResponse(response);
    handler.next(response);
  }

  /// Error interceptor
  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    ApiLogger.logError(error);

    // Handle specific error types
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: ConnectionTimeoutException(),
            type: error.type,
          ),
        );
        break;

      case DioExceptionType.sendTimeout:
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: SendTimeoutException(),
            type: error.type,
          ),
        );
        break;

      case DioExceptionType.receiveTimeout:
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: ReceiveTimeoutException(),
            type: error.type,
          ),
        );
        break;

      case DioExceptionType.cancel:
        handler.reject(
          DioException(
            requestOptions: error.requestOptions,
            error: RequestCancelledException(),
            type: error.type,
          ),
        );
        break;

      case DioExceptionType.badResponse:
        // Handle HTTP errors
        if (error.response?.statusCode == ApiConstant.statusUnauthorized) {
          final hadAuthHeader =
              error.requestOptions.headers[ApiConstant.authorization] != null;
          await _handleTokenExpiry(wasAuthenticated: hadAuthHeader);
        }
        handler.next(error);
        break;

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              error: NoInternetException(),
              type: error.type,
            ),
          );
        } else {
          handler.next(error);
        }
        break;

      default:
        handler.next(error);
    }
  }

  /// Handle token expiry / unauthorized for authenticated sessions only.
  Future<void> _handleTokenExpiry({required bool wasAuthenticated}) async {
    if (!wasAuthenticated) {
      ApiLogger.log('401 received without active session — ignoring redirect');
      return;
    }

    ApiLogger.log('Token expired - clearing auth session');

    await AuthSessionSync.clearSession();

    AppNavigator.pushAndClearStack(const LoginRoute());

    AppNavigator.showSnackBar(
      message: ApiConstant.sessionTimeout,
      backgroundColor: null,
    );
  }

  // ── HTTP Methods ────────────────────────────────────────────────────────

  /// GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// PATCH request
  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
