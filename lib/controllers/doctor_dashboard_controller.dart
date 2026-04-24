import 'package:get/get.dart';
import '../models/appointment_model.dart';
import '../models/doctor_model.dart';
import '../models/prescription_model.dart';
import '../services/patient_session_service.dart';

/// Controller for doctor dashboard
class DoctorDashboardController extends GetxController {
  final isLoading = false.obs;
  final doctor = Rx<Doctor?>(null);
  final pendingAppointments = <Appointment>[].obs;
  final completedAppointments = <Appointment>[].obs;
  final totalPatients = 0.obs;
  final totalEarnings = 0.0.obs;
  final pendingPrescriptions = <Prescription>[].obs;

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
        id: '1',
        fullName: 'Dr. John Doe',
        email: 'john@example.com',
        mobileNumber: '9876543210',
        qualification: 'MBBS',
        specialization: 'Cardiology',
        yearsOfExperience: 10,
        clinicAddress: '123 Medical Street, City',
        licenseNumber: 'LIC123456',
        availability: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
        status: 'approved',
        createdAt: DateTime.now(),
      );

      // TODO: Fetch pending appointments
      pendingAppointments.value = [
        Appointment(
          id: '1',
          doctorId: '1',
          patientId: 'P1',
          patientName: 'Patient One',
          mode: 'Virtual',
          appointmentDate: DateTime.now().add(const Duration(days: 1)),
          timeSlot: '10:00 AM - 10:30 AM',
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
        Appointment(
          id: '2',
          doctorId: '1',
          patientId: 'P2',
          patientName: 'Patient Two',
          mode: 'In-Person',
          appointmentDate: DateTime.now().add(const Duration(days: 2)),
          timeSlot: '02:00 PM - 02:30 PM',
          status: 'Pending',
          createdAt: DateTime.now(),
        ),
      ];

      // TODO: Fetch completed appointments
      completedAppointments.value = [
        Appointment(
          id: '3',
          doctorId: '1',
          patientId: 'P3',
          patientName: 'Patient Three',
          mode: 'Virtual',
          appointmentDate: DateTime.now().subtract(const Duration(days: 5)),
          timeSlot: '09:00 AM - 09:30 AM',
          status: 'Completed',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ];

      totalPatients.value = 45;
      totalEarnings.value = 15000.0;
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

  /// Navigate to payments screen
  void viewPayments() {
    Get.toNamed('/doctor_payments');
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
