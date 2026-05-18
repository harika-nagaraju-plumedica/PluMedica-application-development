import '../models/generic_api_response.dart';
import '../models/sos_response.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class SosRepository {
  SosRepository(this._apiService);

  final PatientApiService _apiService;

  Future<SOSResponse> triggerSOS() async {
    final raw = await _apiService.post(
      '/api/patient/sos/trigger',
      <String, dynamic>{},
    );

    final response = GenericApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      fromData: (data) {
        if (data is Map<String, dynamic>) {
          return data;
        }
        return <String, dynamic>{};
      },
    );

    if (!response.success) {
      throw PatientApiException(
        message: response.message.isEmpty
            ? 'Unable to trigger SOS alert.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return SOSResponse.fromJson(response.data ?? <String, dynamic>{});
  }
}
