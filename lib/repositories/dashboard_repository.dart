import '../models/dashboard_model.dart';
import '../models/generic_api_response.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class DashboardRepository {
  DashboardRepository(this._apiService);

  final PatientApiService _apiService;

  Future<DashboardModel> fetchDashboard() async {
    final raw = await _apiService.get('/api/patient/dashboard');
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
            ? 'Failed to load dashboard.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return DashboardModel.fromJson(response.data ?? <String, dynamic>{});
  }
}
