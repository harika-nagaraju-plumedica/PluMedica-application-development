import 'package:get/get.dart';
import '../../controllers/patient/patient_health_records_controller.dart';

class PatientHealthRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientHealthRecordsController>(
      () => PatientHealthRecordsController(),
    );
  }
}
