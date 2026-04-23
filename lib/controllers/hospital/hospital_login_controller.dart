import 'package:get/get.dart';

class HospitalLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'admin@citymedical.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    email.value = 'admin@citymedical.com';
    password.value = 'demo123';
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/hospital/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}
