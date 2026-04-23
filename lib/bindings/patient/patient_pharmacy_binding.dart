import 'package:get/get.dart';
import '../../controllers/patient/patient_pharmacy_controller.dart';

class PatientPharmacyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientPharmacyController>(
      () => PatientPharmacyController(),
    );
  }
}
