import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_login_controller.dart';

class PharmacyLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyLoginController>(
      () => PharmacyLoginController(),
    );
  }
}
