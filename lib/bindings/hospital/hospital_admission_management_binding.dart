import 'package:get/get.dart';
import '../../controllers/hospital/hospital_admission_management_controller.dart';

class HospitalAdmissionManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalAdmissionManagementController>(
      () => HospitalAdmissionManagementController(),
    );
  }
}
