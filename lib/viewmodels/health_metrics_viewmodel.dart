import '../models/health_metric_model.dart';
import '../repositories/health_metrics_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class HealthMetricsViewModel extends BaseViewModel {
  HealthMetricsViewModel(this._repository);

  final HealthMetricsRepository _repository;

  HealthMetric? _latestMetric;
  HealthMetric? get latestMetric => _latestMetric;

  Future<bool> addHealthMetric(AddHealthMetricRequest request) async {
    setLoading(true);
    clearMessages();

    try {
      _latestMetric = await _repository.addHealthMetric(request);
      setSuccess('Health metric added successfully.');
      return true;
    } on PatientApiException catch (error) {
      setError(error.message);
      return false;
    } catch (_) {
      setError('Unable to add health metric right now.');
      return false;
    } finally {
      setLoading(false);
    }
  }
}
