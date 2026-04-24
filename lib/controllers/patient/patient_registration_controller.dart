import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PatientRegistrationController extends GetxController {
  final isLoading = false.obs;
  final fullName = 'Rajesh Kumar'.obs;
  final email = 'rajesh.kumar@email.com'.obs;
  final mobileNumber = '+91-9876543210'.obs;
  final dateOfBirth = '15/06/1990'.obs;
  final gender = 'Male'.obs;
  final bloodGroup = 'O+'.obs;
  final address = '123 Health Street, Medical District, Metro City'.obs;

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
    loadDemoData();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRegistered();
    if (isRegistered) {
      Get.offAllNamed('/patient/login');
    }
  }

  void loadDemoData() {
    fullName.value = 'Rajesh Kumar';
    email.value = 'rajesh.kumar@email.com';
    mobileNumber.value = '+91-9876543210';
    dateOfBirth.value = '15/06/1990';
    gender.value = 'Male';
    bloodGroup.value = 'O+';
    address.value = '123 Health Street, Medical District, Metro City';
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await PatientSessionService.markLoggedIn(email: email.value);
      
      Get.snackbar(
        'Success',
        'Registration successful. Welcome to Plumedica!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/patient/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipToDemo() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/patient/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Navigation failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDateOfBirth() async {
    // TODO: Show date picker
  }
}
