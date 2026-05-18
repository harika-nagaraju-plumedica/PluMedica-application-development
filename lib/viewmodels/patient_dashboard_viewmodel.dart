import '../models/dashboard_model.dart';
import '../repositories/dashboard_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class PatientDashboardViewModel extends BaseViewModel {
  PatientDashboardViewModel(this._repository);

  final DashboardRepository _repository;

  DashboardModel? _dashboard;
  DashboardModel? get dashboard => _dashboard;

  Future<void> fetchDashboard() async {
    setLoading(true);
    clearMessages();

    try {
      _dashboard = await _repository.fetchDashboard();
      setSuccess('Dashboard fetched');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load dashboard right now.');
    } finally {
      setLoading(false);
    }
  }
}
