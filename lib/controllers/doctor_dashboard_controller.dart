import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/prescription_model.dart';
import '../services/admin_identity_service.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';

/// Controller for doctor dashboard
class DoctorDashboardController extends GetxController {
  final _clinicalDataService = Get.isRegistered<ClinicalDataService>()
      ? Get.find<ClinicalDataService>()
      : Get.put(ClinicalDataService(), permanent: true);
  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
    ? Get.find<AdminIdentityService>()
    : Get.put(AdminIdentityService(), permanent: true);

  String get _currentDoctorId =>
    _adminIdentityService.getPrimaryId(AppRole.doctor);

  String get _currentDoctorName =>
    _adminIdentityService.getPrimaryName(AppRole.doctor);

  final isLoading = false.obs;
  final doctor = Rx<Doctor?>(null);
  final pendingAppointments = <Appointment>[].obs;
  final completedAppointments = <Appointment>[].obs;
  final totalPatients = 0.obs;
  final totalEarnings = 0.0.obs;
  final pendingPrescriptions = <Prescription>[].obs;
  final incomingReferralCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  /// Load dashboard data
  Future<void> loadDashboardData() async {
    isLoading.value = true;

    try {
      // TODO: Fetch doctor profile
      doctor.value = Doctor(
        id: _currentDoctorId,
        fullName: _currentDoctorName,
        email: 'priya@example.com',
        mobileNumber: '9876543210',
        qualification: 'MBBS',
        specialization: 'General Medicine',
        yearsOfExperience: 10,
        clinicAddress: '123 Medical Street, City',
        licenseNumber: 'LIC123456',
        availability: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        status: 'approved',
        createdAt: DateTime.now(),
      );

      final doctorAppointments =
          _clinicalDataService.getAppointmentsForDoctor(_currentDoctorId);

      pendingAppointments.assignAll(
        doctorAppointments.where((item) => item.status == 'Waiting').toList(),
      );
      completedAppointments.assignAll(
        doctorAppointments.where((item) => item.status == 'Completed').toList(),
      );

      totalPatients.value =
          doctorAppointments.map((item) => item.patientId).toSet().length;
      totalEarnings.value = pendingAppointments.length * 700.0 +
          completedAppointments.length * 700.0;
        incomingReferralCount.value =
          _clinicalDataService.getDoctorNotificationCount(_currentDoctorId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to appointments screen
  void viewAppointments() {
    Get.toNamed('/doctor_appointments');
  }

  /// Navigate to patient history screen
  void viewPatientHistory() {
    Get.toNamed('/doctor_patient_history');
  }

  /// Navigate to prescriptions screen
  void viewPrescriptions() {
    Get.toNamed('/doctor_prescriptions');
  }

  /// Navigate to doctor workflow guide screen
  void viewWorkflowGuide() {
    Get.toNamed('/doctor_workflow');
  }

  /// Navigate to payments screen
  void viewPayments() {
    Get.toNamed('/doctor_payments');
  }

  /// Doctor actions panel: Prescription
  void openPrescription() {
    Get.toNamed('/doctor_prescriptions');
  }

  /// Doctor actions panel: Order Labs
  void openOrderLabs() {
    Get.snackbar(
      'Diagnostics Notified',
      'Lab request data has been sent to diagnostics.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Doctor actions panel: Schedule Follow-up
  void openScheduleFollowUp() {
    Get.toNamed('/doctor_prescriptions');
  }

  /// Doctor actions panel: Referrals
  void openReferrals() {
    Get.toNamed('/doctor/referrals/form');
  }

  Future<void> openIncomingReferrals() async {
    await Get.toNamed('/doctor/referrals/incoming');
    incomingReferralCount.value =
        _clinicalDataService.getDoctorNotificationCount(_currentDoctorId);
  }

  /// Logout
  Future<void> logout() async {
    await PatientSessionService.logoutRole(AppRole.doctor);
    Get.offAllNamed('/role_selection');
  }

  /// Refresh dashboard
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}
