import 'package:get/get.dart';

class PatientProfileController extends GetxController {
  final isLoading = false.obs;
  final isEditing = false.obs;
  final fullName = 'John Doe'.obs;
  final email = 'john@example.com'.obs;
  final mobileNumber = '9876543210'.obs;
  final dateOfBirth = '15 Jan 1990'.obs;
  final gender = 'Male'.obs;
  final bloodGroup = 'O+'.obs;
  final address = '123 Medical Street, City'.obs;

  Future<void> logOut() async {
    // TODO: Clear user data
    // TODO: Clear authentication token
    Get.offNamed('/patient/login');
  }

  Future<void> editProfile() async {
    isEditing.value = !isEditing.value;
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      // TODO: Update profile in API
      // TODO: Update local cache
      isEditing.value = false;
      Get.snackbar('Success', 'Profile updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    // TODO: Navigate to change password screen
  }

  Future<void> deleteAccount() async {
    // TODO: Show confirmation dialog
    // TODO: Delete account endpoint
  }
}
