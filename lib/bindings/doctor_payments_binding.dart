import 'package:get/get.dart';
import '../controllers/doctor_payments_controller.dart';

/// Binding for doctor payments
class DoctorPaymentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorPaymentsController>(
      () => DoctorPaymentsController(),
    );
  }
}
