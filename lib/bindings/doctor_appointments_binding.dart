import 'package:get/get.dart';
import '../controllers/doctor_appointments_controller.dart';

/// Binding for doctor appointments
class DoctorAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAppointmentsController>(
      () => DoctorAppointmentsController(),
    );
  }
}
