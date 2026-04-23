import 'package:get/get.dart';
import '../../controllers/patient/patient_sos_controller.dart';

class PatientSosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientSosController>(
      () => PatientSosController(),
    );
  }
}
