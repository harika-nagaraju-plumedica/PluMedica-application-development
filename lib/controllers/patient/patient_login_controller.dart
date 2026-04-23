import 'package:get/get.dart';

class PatientLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'rajesh.kumar@email.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    email.value = 'rajesh.kumar@email.com';
    password.value = 'demo123';
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/patient/dashboard');
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
