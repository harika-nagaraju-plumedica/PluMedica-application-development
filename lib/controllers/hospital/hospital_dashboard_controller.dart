import 'package:get/get.dart';

class HospitalDashboardController extends GetxController {
  final isLoading = false.obs;
  final hospitalName = 'City Medical Centre'.obs;
  final totalPatients = 150.obs;
  final totalBeds = 200.obs;
  final occupiedBeds = 125.obs;
  final activeConsultants = 18.obs;
  final emergencyAlerts = 2.obs;
  final pendingAdmissions = 5.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  final consultants = <Map<String, dynamic>>[].obs;
  final admissions = <Map<String, dynamic>>[].obs;
  final emergencies = <Map<String, dynamic>>[].obs;

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      consultants.value = [
        {
          'id': 'DOC001',
          'name': 'Dr. Rajesh Kumar',
          'specialization': 'Cardiology',
          'status': 'Available'
        },
        {
          'id': 'DOC002',
          'name': 'Dr. Priya Sharma',
          'specialization': 'Neurology',
          'status': 'Busy'
        },
        {
          'id': 'DOC003',
          'name': 'Dr. Amit Patel',
          'specialization': 'Orthopedics',
          'status': 'Available'
        },
        {
          'id': 'DOC004',
          'name': 'Dr. Sarah Johnson',
          'specialization': 'Pediatrics',
          'status': 'Available'
        },
      ];

      admissions.value = [
        {
          'id': 'ADM001',
          'patientName': 'John Doe',
          'patientId': 'PAT001',
          'ward': 'A',
          'bed': '101',
          'status': 'Stable',
          'admissionDate': '2026-04-15'
        },
        {
          'id': 'ADM002',
          'patientName': 'Jane Smith',
          'patientId': 'PAT002',
          'ward': 'B',
          'bed': '205',
          'status': 'Recovering',
          'admissionDate': '2026-04-10'
        },
      ];

      emergencies.value = [
        {
          'id': 'EMG001',
          'severity': 'Critical',
          'description': 'Multiple trauma patient',
          'time': '10:30 AM'
        },
        {
          'id': 'EMG002',
          'severity': 'High',
          'description': 'Chest pain - Cardiac alert',
          'time': '11:45 AM'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToConsultantManagement() async {
    Get.toNamed('/hospital/consultant_management');
  }

  Future<void> navigateToAdmissionManagement() async {
    Get.toNamed('/hospital/admission_management');
  }

  Future<void> navigateToEmergencyServices() async {
    Get.toNamed('/hospital/emergency_services');
  }

  Future<void> navigateToPatientRecords() async {
    Get.toNamed('/hospital/patient_records');
  }

  Future<void> navigateToPayments() async {
    Get.toNamed('/hospital/payment_summary');
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }
}
