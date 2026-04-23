import 'package:get/get.dart';

class PatientConsultationController extends GetxController {
  final isLoading = false.obs;
  final consultations = [].obs;
  final upcomingConsultations = [].obs;
  final completedConsultations = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    isLoading.value = true;
    try {
      // TODO: Fetch consultations from API
      // TODO: Separate upcoming and completed
    } catch (e) {
      Get.snackbar('Error', 'Failed to load consultations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startVideoCall(String consultationId) async {
    // TODO: Initialize video call
  }

  Future<void> openChat(String consultationId) async {
    // TODO: Navigate to chat screen
  }

  Future<void> reschedule(String consultationId) async {
    // TODO: Show reschedule dialog
  }

  Future<void> bookDoctor() async {
    // TODO: Navigate to doctor selection screen
  }

  Future<void> refreshConsultations() async {
    await loadConsultations();
  }
}
