import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

/// Binding for registration routes
class RegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(
      () => RegistrationController(),
    );
  }
}
