import '../models/sos_response.dart';
import '../repositories/sos_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class SosViewModel extends BaseViewModel {
  SosViewModel(this._repository);

  final SosRepository _repository;

  SOSResponse? _latestResponse;
  SOSResponse? get latestResponse => _latestResponse;

  Future<bool> triggerSOS() async {
    if (isLoading) {
      return false;
    }

    setLoading(true);
    clearMessages();

    try {
      _latestResponse = await _repository.triggerSOS();
      setSuccess('SOS alert triggered successfully.');
      return true;
    } on PatientApiException catch (error) {
      setError(error.message);
      return false;
    } catch (_) {
      setError('Unable to trigger SOS right now. Please try again.');
      return false;
    } finally {
      setLoading(false);
    }
  }
}
