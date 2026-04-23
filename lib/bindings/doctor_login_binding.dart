import 'package:get/get.dart';
import '../controllers/doctor_login_controller.dart';

/// Binding for doctor login
class DoctorLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorLoginController>(
      () => DoctorLoginController(),
    );
  }
}
