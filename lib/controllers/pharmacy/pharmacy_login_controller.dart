import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PharmacyLoginController extends GetxController {
  final email = RxString('');
  final password = RxString('');
  final isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
  }

  Future<void> _loadRegisteredEmail() async {
    final registeredEmail = await PatientSessionService.getRoleEmail(AppRole.pharmacy);
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    }
  }

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
      await Future.delayed(const Duration(seconds: 1));

      await PatientSessionService.markRoleLoggedIn(
        AppRole.pharmacy,
        email: email.value,
      );

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed('/pharmacy/dashboard');
      });
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
