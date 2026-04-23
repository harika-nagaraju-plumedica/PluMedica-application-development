import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../views/hospital_registration_view.dart';
import '../views/patient_registration_view.dart';

/// Registration controller for managing registration flow
class RegistrationController extends GetxController {
  /// Observable selected registration type
  final Rx<String?> selectedRegistrationType = Rx<String?>(null);

  /// List of available registration types
  final List<String> registrationTypes = [
    'Doctor',
    'Patient',
    'Hospital',
    'Pharmacy',
    'Partners',
    'Jobs',
    'Diagnostics',
  ];

  /// Check if a type is selected
  bool isTypeSelected(String type) {
    return selectedRegistrationType.value == type;
  }

  /// Select a registration type
  void selectRegistrationType(String type) {
    if (selectedRegistrationType.value == type) {
      selectedRegistrationType.value = null;
    } else {
      selectedRegistrationType.value = type;
    }
    update(); // Notify GetBuilder to rebuild
  }

  /// Navigate to the specific registration form
  void submitRegistration() {
    if (selectedRegistrationType.value == null) {
      if (kDebugMode) {
        print('No registration type selected');
      }
      return;
    }

    final selectedType = selectedRegistrationType.value!;

    // Navigate to the specific registration form using Get.toNamed()
    switch (selectedType) {
      case 'Hospital':
        Get.to(() => const HospitalRegistrationView());
        break;
      case 'Doctor':
        Get.toNamed('/doctor_registration');
        break;
      case 'Patient':
        Get.to(() => const PatientRegistrationView());
        break;
      case 'Pharmacy':
        Get.toNamed('/pharmacy/registration');
        break;
      case 'Partners':
        // Add partners registration when created
        Get.snackbar('Info', 'Partners registration form coming soon');
        break;
      case 'Jobs':
        // Add jobs registration when created
        Get.snackbar('Info', 'Jobs registration form coming soon');
        break;
      case 'Diagnostics':
        // Add diagnostics registration when created
        Get.snackbar('Info', 'Diagnostics registration form coming soon');
        break;
      default:
        if (kDebugMode) {
          print('Unknown registration type: $selectedType');
        }
    }
  }

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print('RegistrationController initialized');
    }
  }

  @override
  void onClose() {
    super.onClose();
    if (kDebugMode) {
      print('RegistrationController disposed');
    }
  }
}
