import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_dashboard_controller.dart';

class DiagnosticsDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiagnosticsDashboardController>(
      () => DiagnosticsDashboardController(),
    );
  }
}
