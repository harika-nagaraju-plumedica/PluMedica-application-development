import 'package:dio/dio.dart';

import 'base_api_service.dart';
import 'patient_api_exception.dart';

class PatientApiService extends BaseApiService {
  PatientApiService({
    Dio? dio,
    String? baseUrl,
    String? token,
    Duration timeout = const Duration(seconds: 20),
    int retryCount = 1,
  }) : super(
          dio: dio,
          baseUrl: baseUrl,
          token: token,
          timeout: timeout,
          retryCount: retryCount,
        );

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await executeWithRetry(
        () => client.get<Map<String, dynamic>>(
          endpoint,
          queryParameters: queryParameters,
        ),
      );
      return handleResponse(response);
    } on DioException catch (error) {
      throw mapDioError(error);
    } on PatientApiException {
      rethrow;
    } catch (error) {
      throw PatientApiException(
        message: 'Unexpected error while requesting data.',
        type: PatientApiErrorType.unknown,
        cause: error,
      );
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await executeWithRetry(
        () => client.put<Map<String, dynamic>>(
          endpoint,
          data: body,
        ),
      );
      return handleResponse(response);
    } on DioException catch (error) {
      throw mapDioError(error);
    } on PatientApiException {
      rethrow;
    } catch (error) {
      throw PatientApiException(
        message: 'Unexpected error while updating data.',
        type: PatientApiErrorType.unknown,
        cause: error,
      );
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await executeWithRetry(
        () => client.post<Map<String, dynamic>>(
          endpoint,
          data: body,
        ),
      );
      return handleResponse(response);
    } on DioException catch (error) {
      throw mapDioError(error);
    } on PatientApiException {
      rethrow;
    } catch (error) {
      throw PatientApiException(
        message: 'Unexpected error while creating data.',
        type: PatientApiErrorType.unknown,
        cause: error,
      );
    }
  }

}
