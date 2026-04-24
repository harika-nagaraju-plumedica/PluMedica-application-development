import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PatientLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'rajesh.kumar@email.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredUser();
    password.value = 'demo123';
  }

  Future<void> _loadRegisteredUser() async {
    final registeredEmail = await PatientSessionService.getRegisteredEmail();
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    } else {
      email.value = 'rajesh.kumar@email.com';
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markLoggedIn(email: email.value);
      Get.offAllNamed('/patient/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    // TODO: Navigate to forgot password screen
  }
}
