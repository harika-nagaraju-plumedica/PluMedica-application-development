import 'package:get/get.dart';
import '../../services/api_exception.dart';
import '../../services/registration_service.dart';
import '../../services/patient_session_service.dart';

class PatientRegistrationController extends GetxController {
  final _registrationService = RegistrationService();

  final isLoading = false.obs;
  final fullName = 'Rajesh Kumar'.obs;
  final email = 'rajesh.kumar@email.com'.obs;
  final mobileNumber = '+91-9876543210'.obs;
  final password = ''.obs;
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
    password.value = '';
    dateOfBirth.value = '15/06/1990';
    gender.value = 'Male';
    bloodGroup.value = 'O+';
    address.value = '123 Health Street, Medical District, Metro City';
  }

  Future<void> register() async {
    if (fullName.value.trim().isEmpty ||
        email.value.trim().isEmpty ||
        mobileNumber.value.trim().isEmpty ||
        password.value.isEmpty) {
      Get.snackbar('Validation', 'Please fill all required fields');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _registrationService.registerPatient(
        fullName: fullName.value.trim(),
        email: email.value.trim(),
        mobile: mobileNumber.value.trim(),
        password: password.value,
        gender: gender.value.trim(),
        bloodGroup: bloodGroup.value.trim(),
        address: address.value.trim(),
      );

      await PatientSessionService.markLoggedIn(
        email: email.value,
        displayName: fullName.value.trim(),
      );

      Get.snackbar(
        'Success',
        response.message.isEmpty
            ? 'Registration successful. Welcome to Plumedica!'
            : response.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/patient/dashboard');
    } on ApiException catch (e) {
      Get.snackbar('Registration Failed', e.message);
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
