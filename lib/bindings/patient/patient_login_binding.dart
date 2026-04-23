import 'package:get/get.dart';
import '../../controllers/patient/patient_login_controller.dart';

class PatientLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientLoginController>(
      () => PatientLoginController(),
    );
  }
}
