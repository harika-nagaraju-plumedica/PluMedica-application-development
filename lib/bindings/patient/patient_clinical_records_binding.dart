import 'package:get/get.dart';

import '../../controllers/patient/patient_clinical_records_controller.dart';

class PatientClinicalRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientClinicalRecordsController>(
      () => PatientClinicalRecordsController(),
    );
  }
}
