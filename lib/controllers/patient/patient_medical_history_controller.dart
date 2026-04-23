import 'package:get/get.dart';

class PatientMedicalHistoryController extends GetxController {
  final isLoading = false.obs;
  final medicalHistory = [].obs;
  final selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicalHistory();
  }

  Future<void> loadMedicalHistory() async {
    isLoading.value = true;
    try {
      // TODO: Fetch medical history from API
      // Sample data structure for TODOs
      medicalHistory.value = [];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medical history');
    } finally {
      isLoading.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    // TODO: Filter medical history
  }

  Future<void> viewDetails(String historyId) async {
    // TODO: Navigate to detail view
  }
}
