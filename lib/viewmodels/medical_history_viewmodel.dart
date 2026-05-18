import '../models/medical_history_model.dart';
import '../repositories/medical_history_repository.dart';
import '../services/patient_api_exception.dart';
import 'base_view_model.dart';

class MedicalHistoryViewModel extends BaseViewModel {
  MedicalHistoryViewModel(this._repository);

  final MedicalHistoryRepository _repository;

  List<Appointment> _appointments = <Appointment>[];
  List<Appointment> get appointments => _appointments;

  Meta? _meta;
  Meta? get meta => _meta;

  DateTime? _fromDate;
  DateTime? get fromDate => _fromDate;

  DateTime? _toDate;
  DateTime? get toDate => _toDate;

  bool get hasActiveFilter => _fromDate != null && _toDate != null;

  Future<void> fetchAllMedicalHistory({
    int page = 1,
    int limit = 10,
  }) async {
    setLoading(true);
    clearMessages();

    try {
      final history = await _repository.fetchAllMedicalHistory(
        page: page,
        limit: limit,
      );

      _appointments = history.appointments;
      _meta = history.meta;
      setSuccess('Medical history fetched.');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load medical history right now.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchAppointmentsWithDateFilter({
    required DateTime from,
    required DateTime to,
    int page = 1,
    int limit = 10,
  }) async {
    setLoading(true);
    clearMessages();

    _fromDate = from;
    _toDate = to;

    try {
      final history = await _repository.fetchAppointmentsWithDateFilter(
        from: _asDateParam(from),
        to: _asDateParam(to),
        page: page,
        limit: limit,
      );

      _appointments = history.appointments;
      _meta = history.meta;
      setSuccess('Appointments fetched.');
    } on PatientApiException catch (error) {
      setError(error.message);
    } catch (_) {
      setError('Unable to load filtered appointments right now.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> clearFilterAndReload({
    int page = 1,
    int limit = 10,
  }) async {
    _fromDate = null;
    _toDate = null;
    notifyListeners();
    await fetchAllMedicalHistory(page: page, limit: limit);
  }

  String formatDateRange() {
    if (_fromDate == null || _toDate == null) {
      return 'No active date filter';
    }
    return '${_asDateParam(_fromDate!)} to ${_asDateParam(_toDate!)}';
  }

  String _asDateParam(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    return '${value.year}-$month-$day';
  }
}
