import '../models/latest_metrics.dart';
import '../models/metric_history.dart';
import '../models/generic_api_response.dart';
import '../models/health_metric_model.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class HealthMetricsRepository {
  HealthMetricsRepository(this._apiService);

  final PatientApiService _apiService;

  Future<LatestMetrics> fetchLatestMetrics({
    List<String> metricTypes = const <String>[
      'BP_SYS',
      'BP_DIA',
      'HEART_RATE',
      'WEIGHT',
      'SPO2',
    ],
  }) async {
    final raw = await _apiService.get(
      '/api/patient/health-metrics/latest',
      queryParameters: <String, dynamic>{
        'metricTypes': metricTypes.join(','),
      },
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
            ? 'Failed to fetch latest metrics.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return LatestMetrics.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<MetricHistory> fetchMetricHistory({
    required String metricType,
    required String from,
    required String to,
    int page = 1,
    int limit = 10,
  }) async {
    final raw = await _apiService.get(
      '/api/patient/health-metrics/history',
      queryParameters: <String, dynamic>{
        'metricType': metricType,
        'from': from,
        'to': to,
        'page': page,
        'limit': limit,
      },
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
            ? 'Failed to fetch metric history.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return MetricHistory.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<HealthMetric> addHealthMetric(AddHealthMetricRequest request) async {
    final raw = await _apiService.post(
      '/api/patient/health-metrics',
      request.toJson(),
    );

    final response = GenericApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      fromData: (data) =>
          data is Map<String, dynamic> ? data : <String, dynamic>{},
    );

    if (!response.success) {
      throw PatientApiException(
        message: response.message.isEmpty
            ? 'Failed to add health metric.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    final data = response.data ?? <String, dynamic>{};
    final metricMap = data['metric'] is Map<String, dynamic>
        ? data['metric'] as Map<String, dynamic>
        : <String, dynamic>{};

    return HealthMetric.fromJson(metricMap);
  }
}
