import 'package:get/get.dart';

class PharmacyLoginController extends GetxController {
  final email = RxString('');
  final password = RxString('');
  final isLoading = RxBool(false);

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      // TODO: Replace with actual API call
      // For now, simulate login delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation - in production, validate against backend
      if (email.value == 'pharmacy@plumedica.com' &&
          password.value == 'password123') {
        Get.snackbar(
          'Success',
          'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );

        // Navigate to pharmacy dashboard
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offNamed('/pharmacy/dashboard');
        });
      } else {
        Get.snackbar(
          'Error',
          'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    email.value = '';
    password.value = '';
    super.onClose();
  }
}
