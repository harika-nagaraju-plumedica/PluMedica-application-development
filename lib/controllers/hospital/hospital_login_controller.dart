import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class HospitalLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'admin@citymedical.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
    password.value = 'demo123';
  }

  Future<void> _loadRegisteredEmail() async {
    final registeredEmail = await PatientSessionService.getRoleEmail(AppRole.hospital);
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    } else {
      email.value = 'admin@citymedical.com';
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.hospital,
        email: email.value,
      );
      Get.offAllNamed('/hospital/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}
