import 'package:get/get.dart';

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
    loadDemoData();
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
      
      Get.snackbar(
        'Success',
        'Patient registration submitted. Status: Pending Verification',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      
      // Navigate to pending verification page after snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/pending-verification', arguments: {
        'registrationType': 'Patient',
        'userEmail': email.value,
      });
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
