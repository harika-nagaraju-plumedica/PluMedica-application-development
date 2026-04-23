import 'package:get/get.dart';
import '../../controllers/patient/patient_consultation_controller.dart';

class PatientConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientConsultationController>(
      () => PatientConsultationController(),
    );
  }
}
