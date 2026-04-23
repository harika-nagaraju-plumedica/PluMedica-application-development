import 'package:get/get.dart';
import '../../controllers/patient/patient_medical_history_controller.dart';

class PatientMedicalHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientMedicalHistoryController>(
      () => PatientMedicalHistoryController(),
    );
  }
}
