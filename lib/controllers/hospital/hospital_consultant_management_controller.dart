import 'package:get/get.dart';

class HospitalConsultantManagementController extends GetxController {
  final isLoading = false.obs;
  final consultants = [].obs;
  final availableConsultants = [].obs;
  final busyConsultants = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadConsultants();
  }

  Future<void> loadConsultants() async {
    isLoading.value = true;
    try {
      // TODO: Fetch consultants list
      // TODO: Separate available and busy
    } catch (e) {
      Get.snackbar('Error', 'Failed to load consultants');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addConsultant() async {
    // TODO: Navigate to add consultant form
  }

  Future<void> editConsultant(String consultantId) async {
    // TODO: Navigate to edit form
  }

  Future<void> viewConsultantDetails(String consultantId) async {
    // TODO: Navigate to consultant details
  }

  Future<void> removeConsultant(String consultantId) async {
    // TODO: Show confirmation and delete
  }
}
