import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';
import 'api_exception.dart';

class DioService {
  static const Duration _hardTimeout = Duration(seconds: 15);

  DioService()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: const {
              'Accept': 'application/json',
            },
          ),
        );

  final Dio _dio;

  Future<Map<String, dynamic>> postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: body,
        options: Options(headers: const {'Content-Type': 'application/json'}),
      ).timeout(_hardTimeout);
      return response.data ?? <String, dynamic>{};
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timed out. Please check your internet and try again.',
        cause: e,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on FormatException catch (e) {
      throw ApiException(
        message: 'Invalid API URL configuration. Set BASE_URL using --dart-define=BASE_URL=https://your-api-host.com',
        cause: e,
      );
    } catch (e) {
      throw ApiException(
        message: ApiEndpoints.isUsingFallbackBaseUrl
            ? 'API not configured. Using fallback ${ApiEndpoints.baseUrl}. Start your backend there or run with --dart-define=BASE_URL=https://your-api-host.com'
            : 'Unexpected error occurred: ${e.toString()}',
        cause: e,
      );
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, dynamic> fields,
    required Map<String, PlatformFile?> files,
  }) async {
    try {
      final formMap = <String, dynamic>{...fields};

      for (final entry in files.entries) {
        final file = entry.value;
        if (file == null) {
          continue;
        }

        // On web, accessing PlatformFile.path throws. Use bytes directly.
        if (kIsWeb) {
          if (file.bytes != null && file.bytes!.isNotEmpty) {
            formMap[entry.key] = MultipartFile.fromBytes(
              file.bytes!,
              filename: file.name,
            );
            continue;
          }

          throw ApiException(
            message: 'Selected file for ${entry.key} has no bytes on web',
          );
        }

        if (file.path != null && file.path!.isNotEmpty) {
          formMap[entry.key] = await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          );
          continue;
        }

        if (file.bytes != null && file.bytes!.isNotEmpty) {
          formMap[entry.key] = MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          );
          continue;
        }

        throw ApiException(
          message: 'Selected file for ${entry.key} has no usable path or bytes',
        );
      }

      final response = await _dio.post<Map<String, dynamic>>(
        endpoint,
        data: FormData.fromMap(formMap),
        options: Options(
          headers: const {'Content-Type': 'multipart/form-data'},
        ),
      ).timeout(_hardTimeout);

      return response.data ?? <String, dynamic>{};
    } on TimeoutException catch (e) {
      throw ApiException(
        message: 'Request timed out. Please check your internet and try again.',
        cause: e,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    } on FormatException catch (e) {
      throw ApiException(
        message: 'Invalid API URL configuration. Set BASE_URL using --dart-define=BASE_URL=https://your-api-host.com',
        cause: e,
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: ApiEndpoints.isUsingFallbackBaseUrl
            ? 'API not configured. Using fallback ${ApiEndpoints.baseUrl}. Start your backend there or run with --dart-define=BASE_URL=https://your-api-host.com'
            : 'Unexpected error occurred: ${e.toString()}',
        cause: e,
      );
    }
  }

  ApiException _mapDioError(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      return ApiException(
        message: (data['message'] ?? 'Request failed').toString(),
        errorCode: data['errorCode']?.toString(),
        statusCode: statusCode,
        cause: exception,
      );
    }

    final fallbackMessage = exception.type == DioExceptionType.connectionTimeout
        ? 'Connection timed out. Please try again.'
        : exception.type == DioExceptionType.receiveTimeout
            ? 'Server response timed out. Please try again.'
            : exception.type == DioExceptionType.connectionError
                ? 'Unable to connect to server. Check network and BASE_URL.'
                : 'Something went wrong. Please try again.';

    return ApiException(
      message: fallbackMessage,
      statusCode: statusCode,
      cause: exception,
    );
  }
}
