import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PatientDashboardController extends GetxController {
  final isLoading = false.obs;
  final patientName = 'Rajesh Kumar'.obs;
  final profileImage = 'assets/images/logo.jpeg'.obs;
  final healthScore = 85.obs;
  final lastCheckup = 'April 10, 2026'.obs;
  final upcomingAppointments = 2.obs;
  
  // Health metrics
  final heartRate = 72.obs;
  final bloodPressure = '120/80'.obs;
  final temperature = 98.6.obs;
  final weight = 75.0.obs;
  
  // Lists
  final appointments = <Map<String, dynamic>>[].obs;
  final prescriptions = <Map<String, dynamic>>[].obs;
  final medicalRecords = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      appointments.value = [
        {
          'id': 'APT001',
          'doctorName': 'Dr. Priya Sharma',
          'specialty': 'General Medicine',
          'date': 'April 20, 2026',
          'time': '10:00 AM',
          'status': 'Scheduled'
        },
        {
          'id': 'APT002',
          'doctorName': 'Dr. Rajesh Kumar',
          'specialty': 'Cardiology',
          'date': 'April 25, 2026',
          'time': '2:00 PM',
          'status': 'Scheduled'
        },
      ];

      prescriptions.value = [
        {
          'id': 'PRESC001',
          'medicineName': 'Aspirin',
          'dosage': '500mg',
          'frequency': 'Twice daily',
          'duration': '7 days',
          'date': 'April 15, 2026'
        },
        {
          'id': 'PRESC002',
          'medicineName': 'Vitamin D',
          'dosage': '1000 IU',
          'frequency': 'Once daily',
          'duration': '30 days',
          'date': 'April 10, 2026'
        },
      ];

      medicalRecords.value = [
        {
          'id': 'REC001',
          'type': 'Blood Test',
          'date': 'April 10, 2026',
          'doctor': 'Dr. Priya Sharma',
          'status': 'Available'
        },
        {
          'id': 'REC002',
          'type': 'X-Ray',
          'date': 'March 20, 2026',
          'doctor': 'Dr. Amit Patel',
          'status': 'Available'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToMedicalHistory() async {
    Get.toNamed('/patient/medical_history');
  }

  Future<void> navigateToFitness() async {
    Get.toNamed('/patient/fitness');
  }

  Future<void> navigateToConsultation() async {
    Get.toNamed('/patient/consultation');
  }

  Future<void> navigateToHealthRecords() async {
    Get.toNamed('/patient/health_records');
  }

  Future<void> navigateToReferrals() async {
    Get.toNamed('/patient/referrals');
  }

  Future<void> navigateToPharmacy() async {
    Get.toNamed('/patient/pharmacy');
  }

  Future<void> navigateToSOS() async {
    Get.toNamed('/patient/sos');
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  Future<void> logout() async {
    await PatientSessionService.logout();
    Get.offAllNamed('/role_selection');
  }
}
