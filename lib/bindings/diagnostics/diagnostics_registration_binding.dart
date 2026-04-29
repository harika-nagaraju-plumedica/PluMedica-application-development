import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_registration_controller.dart';

class DiagnosticsRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticsRegistrationController>(
      () => DiagnosticsRegistrationController(),
    );
  }
}
