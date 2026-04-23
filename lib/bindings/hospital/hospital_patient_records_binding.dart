import 'package:get/get.dart';
import '../../controllers/hospital/hospital_patient_records_controller.dart';

class HospitalPatientRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalPatientRecordsController>(
      () => HospitalPatientRecordsController(),
    );
  }
}
