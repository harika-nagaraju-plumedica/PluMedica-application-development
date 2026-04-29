import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../services/admin_identity_service.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';

/// Controller for doctor appointments
class DoctorAppointmentsController extends GetxController {
  final _clinicalDataService = Get.isRegistered<ClinicalDataService>()
      ? Get.find<ClinicalDataService>()
      : Get.put(ClinicalDataService(), permanent: true);
  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
    ? Get.find<AdminIdentityService>()
    : Get.put(AdminIdentityService(), permanent: true);

  String get _currentDoctorId =>
    _adminIdentityService.getPrimaryId(AppRole.doctor);

  final isLoading = false.obs;
  final allWaitingAppointments = <Appointment>[].obs;
  final allCompletedAppointments = <Appointment>[].obs;
  final waitingAppointments = <Appointment>[].obs;
  final completedAppointments = <Appointment>[].obs;
  final selectedTab = 'Waiting'.obs;

  final patientIdQuery = ''.obs;
  final selectedDate = Rxn<DateTime>();
  final availableTimeSlots = <String>[
    '09:00 AM - 09:30 AM',
    '09:30 AM - 10:00 AM',
    '10:00 AM - 10:30 AM',
    '10:30 AM - 11:00 AM',
    '11:00 AM - 11:30 AM',
    '11:30 AM - 12:00 PM',
    '02:00 PM - 02:30 PM',
    '02:30 PM - 03:00 PM',
    '03:00 PM - 03:30 PM',
    '03:30 PM - 04:00 PM',
    '04:00 PM - 04:30 PM',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadAppointments();
  }

  /// Load appointments
  Future<void> loadAppointments() async {
    isLoading.value = true;

    try {
      final doctorAppointments = _clinicalDataService
          .getAppointmentsForDoctor(_currentDoctorId);

      allWaitingAppointments.assignAll(
        doctorAppointments.where((item) => item.status == 'Waiting').toList(),
      );
      allCompletedAppointments.assignAll(
        doctorAppointments.where((item) => item.status == 'Completed').toList(),
      );

      _prepareFilterOptions();
      applyFilters();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load appointments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Switch tab
  void switchTab(String tab) {
    selectedTab.value = tab;
  }

  void updatePatientIdQuery(String query) {
    patientIdQuery.value = query.trim();
    applyFilters();
  }

  void selectDate(DateTime? date) {
    selectedDate.value = date;
    applyFilters();
  }

  void clearDateFilter() {
    selectedDate.value = null;
    applyFilters();
  }

  void acceptAppointment(Appointment appointment) {
    _clinicalDataService.updateAppointmentStatus(
      appointmentId: appointment.id,
      status: 'Completed',
      notes: 'Accepted and completed by doctor',
    );
    loadAppointments();

    Get.snackbar(
      'Success',
      'Appointment accepted successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void rejectAppointment(Appointment appointment) {
    _clinicalDataService.removeAppointment(appointment.id);
    loadAppointments();

    Get.snackbar(
      'Success',
      'Appointment rejected',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void postponeAppointment({
    required Appointment appointment,
    required String newTimeSlot,
  }) {
    final requestedSlot =
        _clinicalDataService.getRequestedRescheduleSlot(appointment.id);
    if (requestedSlot == null || requestedSlot.isEmpty) {
      Get.snackbar(
        'Request Needed',
        'Patient must request an available slot first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newTimeSlot != requestedSlot) {
      Get.snackbar(
        'Invalid Slot',
        'Doctor can postpone only to patient requested slot: $requestedSlot',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final day = _weekdayName(appointment.appointmentDate);
    if (!_clinicalDataService.isDoctorSlotFree(
      doctorId: appointment.doctorId,
      day: day,
      slotLabel: newTimeSlot,
    )) {
      Get.snackbar(
        'Unavailable',
        'Requested slot is no longer available.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    _clinicalDataService.setDoctorSlotStatus(
      doctorId: appointment.doctorId,
      day: day,
      slotLabel: appointment.timeSlot,
      status: 'Free',
    );
    _clinicalDataService.setDoctorSlotStatus(
      doctorId: appointment.doctorId,
      day: day,
      slotLabel: newTimeSlot,
      status: 'Booked',
    );

    _clinicalDataService.updateAppointmentTimeSlot(
      appointmentId: appointment.id,
      newTimeSlot: newTimeSlot,
      notes: 'Postponed to $newTimeSlot',
    );
    _clinicalDataService.clearRescheduleRequest(appointment.id);
    loadAppointments();

    Get.snackbar(
      'Success',
      'Appointment postponed to $newTimeSlot',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<String> getRequestedPostponeSlots(Appointment appointment) {
    final requestedSlot =
        _clinicalDataService.getRequestedRescheduleSlot(appointment.id);
    if (requestedSlot == null || requestedSlot.isEmpty) {
      return const [];
    }

    final day = _weekdayName(appointment.appointmentDate);
    final isFree = _clinicalDataService.isDoctorSlotFree(
      doctorId: appointment.doctorId,
      day: day,
      slotLabel: requestedSlot,
    );

    if (!isFree) {
      return const [];
    }
    return [requestedSlot];
  }

  String _weekdayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  void openVirtualConsultation(Appointment appointment) {
    if (appointment.mode != 'Virtual') {
      Get.snackbar(
        'Unavailable',
        'Live video call is only available for virtual appointments.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.toNamed('/doctor_live_call', arguments: {
      'appointmentId': appointment.id,
      'patientId': appointment.patientId,
      'patientName': appointment.patientName,
      'doctorId': appointment.doctorId,
    });
  }

  void applyFilters() {
    waitingAppointments.assignAll(
      _filterAppointments(allWaitingAppointments),
    );
    completedAppointments.assignAll(
      _filterAppointments(allCompletedAppointments),
    );
  }

  List<Appointment> _filterAppointments(List<Appointment> source) {
    return source.where((appointment) {
      final query = patientIdQuery.value.toLowerCase();
      final matchesPatientIdQuery =
          query.isEmpty || appointment.patientId.toLowerCase().contains(query);
      final selected = selectedDate.value;
      final matchesDate =
          selected == null ||
          (appointment.appointmentDate.year == selected.year &&
              appointment.appointmentDate.month == selected.month &&
              appointment.appointmentDate.day == selected.day);

      return matchesPatientIdQuery && matchesDate;
    }).toList();
  }

  void _prepareFilterOptions() {
    // No-op: dropdown filter options removed.
  }

  /// Refresh appointments
  Future<void> refreshAppointments() async {
    await loadAppointments();
  }
}
