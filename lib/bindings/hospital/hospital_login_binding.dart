import 'package:get/get.dart';
import '../../controllers/hospital/hospital_login_controller.dart';

class HospitalLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalLoginController>(
      () => HospitalLoginController(),
    );
  }
}
