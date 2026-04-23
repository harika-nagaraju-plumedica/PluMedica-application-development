import 'package:get/get.dart';
import '../controllers/doctor_registration_controller.dart';

/// Binding for doctor registration
class DoctorRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorRegistrationController>(
      () => DoctorRegistrationController(),
    );
  }
}
