import '../models/generic_api_response.dart';
import '../models/medical_history_model.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class MedicalHistoryRepository {
  MedicalHistoryRepository(this._apiService);

  final PatientApiService _apiService;

  Future<MedicalHistory> fetchAllMedicalHistory({
    int page = 1,
    int limit = 10,
  }) async {
    final raw = await _apiService.get(
      '/api/patient/medical-history',
      queryParameters: <String, dynamic>{
        'type': 'all',
        'page': page,
        'limit': limit,
      },
    );

    final response = GenericApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      fromData: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (!response.success) {
      throw PatientApiException(
        message: response.message.isEmpty
            ? 'Failed to fetch medical history.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return MedicalHistory.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<MedicalHistory> fetchAppointmentsWithDateFilter({
    required String from,
    required String to,
    int page = 1,
    int limit = 10,
  }) async {
    final raw = await _apiService.get(
      '/api/patient/medical-history',
      queryParameters: <String, dynamic>{
        'type': 'appointments',
        'from': from,
        'to': to,
        'page': page,
        'limit': limit,
      },
    );

    final response = GenericApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      fromData: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (!response.success) {
      throw PatientApiException(
        message: response.message.isEmpty
            ? 'Failed to fetch appointments.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return MedicalHistory.fromJson(response.data ?? <String, dynamic>{});
  }
}
