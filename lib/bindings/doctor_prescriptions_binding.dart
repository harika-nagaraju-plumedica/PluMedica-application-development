import 'package:get/get.dart';
import '../controllers/doctor_prescriptions_controller.dart';

/// Binding for doctor prescriptions
class DoctorPrescriptionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorPrescriptionsController>(
      () => DoctorPrescriptionsController(),
    );
  }
}
