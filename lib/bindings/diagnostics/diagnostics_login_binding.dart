import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_login_controller.dart';

class DiagnosticsLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticsLoginController>(() => DiagnosticsLoginController());
  }
}
