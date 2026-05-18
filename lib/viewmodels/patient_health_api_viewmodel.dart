import '../models/emergency_contact.dart';
import '../models/latest_metrics.dart';
import '../models/metric_history.dart';
import '../repositories/emergency_contact_repository.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class PatientHealthApiViewModel extends BaseViewModel {
  PatientHealthApiViewModel(
    this._healthMetricsRepository,
    this._emergencyContactRepository,
  );

  final HealthMetricsRepository _healthMetricsRepository;
  final EmergencyContactRepository _emergencyContactRepository;

  LatestMetrics? _latestMetrics;
  LatestMetrics? get latestMetrics => _latestMetrics;

  MetricHistory? _metricHistory;
  MetricHistory? get metricHistory => _metricHistory;

  EmergencyContact? _lastCreatedContact;
  EmergencyContact? get lastCreatedContact => _lastCreatedContact;

  Future<void> fetchLatestMetrics({
    List<String> metricTypes = const <String>[
      'BP_SYS',
      'BP_DIA',
      'HEART_RATE',
      'WEIGHT',
      'SPO2',
    ],
  }) async {
    setLoading(true);
    clearMessages();

    try {
      _latestMetrics = await _healthMetricsRepository.fetchLatestMetrics(
        metricTypes: metricTypes,
      );
      setSuccess('Latest metrics fetched.');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load latest metrics right now.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchMetricHistory({
    required String metricType,
    required DateTime from,
    required DateTime to,
    int page = 1,
    int limit = 10,
  }) async {
    setLoading(true);
    clearMessages();

    try {
      _metricHistory = await _healthMetricsRepository.fetchMetricHistory(
        metricType: metricType,
        from: _toDateParam(from),
        to: _toDateParam(to),
        page: page,
        limit: limit,
      );
      setSuccess('Metric history fetched.');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load metric history right now.');
    } finally {
      setLoading(false);
    }
  }

  Future<bool> createEmergencyContact(CreateEmergencyContactRequest request) async {
    setLoading(true);
    clearMessages();

    try {
      _lastCreatedContact = await _emergencyContactRepository
          .createEmergencyContact(request);
      setSuccess('Emergency contact created successfully.');
      return true;
    } on PatientApiException catch (error) {
      setError(error.message);
      return false;
    } catch (_) {
      setError('Unable to create emergency contact right now.');
      return false;
    } finally {
      setLoading(false);
    }
  }

  String _toDateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }
}
