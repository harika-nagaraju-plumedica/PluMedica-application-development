import 'package:get/get.dart';

class PatientMedicalHistoryController extends GetxController {
  final isLoading = false.obs;
  final allMedicalHistory = <Map<String, dynamic>>[].obs;
  final medicalHistory = <Map<String, dynamic>>[].obs;
  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicalHistory();
  }

  Future<void> loadMedicalHistory() async {
    isLoading.value = true;
    try {
      allMedicalHistory.assignAll([
        {
          'id': 'MH-1001',
          'category': 'Appointments',
          'title': 'Cardiology Follow-up',
          'description': 'Follow-up consultation for blood pressure review.',
          'date': 'Apr 22, 2026',
          'doctorName': 'Amit Patel',
        },
        {
          'id': 'MH-1002',
          'category': 'Medications',
          'title': 'Hypertension Medication Update',
          'description': 'Amlodipine adjusted from 5mg to 2.5mg at night.',
          'date': 'Apr 24, 2026',
          'doctorName': 'Priya Sharma',
        },
        {
          'id': 'MH-1003',
          'category': 'Tests',
          'title': 'Complete Blood Count (CBC)',
          'description': 'Routine CBC with normal hemoglobin and platelets.',
          'date': 'Apr 26, 2026',
          'doctorName': 'Nisha Verma',
        },
        {
          'id': 'MH-1004',
          'category': 'Appointments',
          'title': 'Dermatology Consultation',
          'description': 'Assessment for allergic skin rash and itching.',
          'date': 'Apr 10, 2026',
          'doctorName': 'Nisha Verma',
        },
      ]);
      filterByCategory(selectedCategory.value);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medical history');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      medicalHistory.assignAll(allMedicalHistory);
      return;
    }

    medicalHistory.assignAll(
      allMedicalHistory.where((item) => item['category'] == category).toList(),
    );
  }

  Future<void> viewDetails(String historyId) async {
    final history = allMedicalHistory.firstWhereOrNull(
      (item) => item['id'] == historyId,
    );
    if (history == null) {
      return;
    }

    Get.snackbar(
      history['title'] as String,
      history['description'] as String,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
