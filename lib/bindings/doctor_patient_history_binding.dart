import 'package:get/get.dart';
import '../controllers/doctor_patient_history_controller.dart';

/// Binding for doctor patient history
class DoctorPatientHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorPatientHistoryController>(
      () => DoctorPatientHistoryController(),
    );
  }
}
