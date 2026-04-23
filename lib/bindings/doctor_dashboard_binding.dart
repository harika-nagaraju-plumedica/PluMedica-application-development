import 'package:get/get.dart';
import '../controllers/doctor_dashboard_controller.dart';

/// Binding for doctor dashboard
class DoctorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorDashboardController>(
      () => DoctorDashboardController(),
    );
  }
}
