import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'patient_api_config.dart';
import 'patient_api_exception.dart';

abstract class BaseApiService {
  BaseApiService({
    Dio? dio,
    String? baseUrl,
    String? token,
    Duration timeout = const Duration(seconds: 20),
    int retryCount = 1,
    Duration hardTimeout = const Duration(seconds: 15),
  })  : _token = (token ?? PatientApiConfig.token).trim(),
        _retryCount = retryCount,
      _hardTimeout = hardTimeout,
        _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: _resolveBaseUrl(baseUrl),
                connectTimeout: timeout,
                receiveTimeout: timeout,
                sendTimeout: timeout,
                headers: const <String, dynamic>{
                  'Content-Type': 'application/json',
                  'Accept': 'application/json',
                },
              ),
            ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token.isNotEmpty && options.headers['Authorization'] == null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[API] ${response.requestOptions.method} ${response.requestOptions.path} -> ${response.statusCode}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[API ERROR] ${error.requestOptions.method} ${error.requestOptions.path} -> ${error.response?.statusCode}',
            );
          }
          handler.next(error);
        },
      ),
    );
  }

  final Dio _dio;
  final String _token;
  final int _retryCount;
  final Duration _hardTimeout;

  Dio get client => _dio;

  Future<Response<Map<String, dynamic>>> executeWithRetry(
    Future<Response<Map<String, dynamic>>> Function() action,
  ) async {
    var attempt = 0;
    while (true) {
      attempt += 1;
      try {
        return await action().timeout(_hardTimeout);
      } on TimeoutException catch (error) {
        final shouldRetry = attempt <= _retryCount;
        if (!shouldRetry) {
          throw PatientApiException(
            message:
                'Request timed out. Please check your internet connection and try again.',
            type: PatientApiErrorType.timeout,
            cause: error,
          );
        }
        await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
      } on DioException catch (error) {
        final shouldRetry = _shouldRetry(error) && attempt <= _retryCount;
        if (!shouldRetry) {
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 250 * attempt));
      }
    }
  }

  bool _shouldRetry(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    final status = error.response?.statusCode ?? 0;
    return status >= 500;
  }

  PatientApiException mapDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _extractMessage(error.response?.data);

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      return PatientApiException(
        message: 'Request timeout. Please try again.',
        statusCode: statusCode,
        type: PatientApiErrorType.timeout,
        cause: error,
      );
    }

    if (error.type == DioExceptionType.connectionError) {
      return PatientApiException(
        message: 'Network error. Check your internet connection.',
        statusCode: statusCode,
        type: PatientApiErrorType.network,
        cause: error,
      );
    }

    if (statusCode == 400) {
      return PatientApiException(
        message: message ?? 'Bad request.',
        statusCode: statusCode,
        type: PatientApiErrorType.badRequest,
        cause: error,
      );
    }

    if (statusCode == 401) {
      return PatientApiException(
        message: message ?? 'Unauthorized. Token may be invalid or expired.',
        statusCode: statusCode,
        type: PatientApiErrorType.unauthorized,
        cause: error,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return PatientApiException(
        message: message ?? 'Server error. Please try again later.',
        statusCode: statusCode,
        type: PatientApiErrorType.server,
        cause: error,
      );
    }

    return PatientApiException(
      message: message ?? 'Unexpected API error.',
      statusCode: statusCode,
      type: PatientApiErrorType.unknown,
      cause: error,
    );
  }

  Map<String, dynamic> handleResponse(Response<Map<String, dynamic>> response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    if (statusCode >= 200 && statusCode < 300) {
      return data ?? <String, dynamic>{};
    }

    final message = _extractMessage(data) ?? 'Request failed.';

    if (statusCode == 400) {
      throw PatientApiException(
        message: message,
        statusCode: statusCode,
        type: PatientApiErrorType.badRequest,
      );
    }

    if (statusCode == 401) {
      throw PatientApiException(
        message: message,
        statusCode: statusCode,
        type: PatientApiErrorType.unauthorized,
      );
    }

    if (statusCode >= 500) {
      throw PatientApiException(
        message: message,
        statusCode: statusCode,
        type: PatientApiErrorType.server,
      );
    }

    throw PatientApiException(
      message: message,
      statusCode: statusCode,
      type: PatientApiErrorType.unknown,
    );
  }

  String? extractMessage(dynamic data) {
    return _extractMessage(data);
  }

  static String _resolveBaseUrl(String? overrideBaseUrl) {
    final value = (overrideBaseUrl ?? PatientApiConfig.baseUrl).trim();
    if (value.isEmpty) {
      throw const PatientApiException(
        message:
            'BASE_URL is missing. Pass --dart-define=BASE_URL=https://your-api-host.com',
      );
    }
    return value;
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString().trim();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }
    return null;
  }
}
