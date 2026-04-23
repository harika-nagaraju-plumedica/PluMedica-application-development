import 'package:get/get.dart';
import '../../controllers/patient/patient_dashboard_controller.dart';

class PatientDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientDashboardController>(
      () => PatientDashboardController(),
    );
  }
}
