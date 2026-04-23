import 'package:get/get.dart';
import '../../controllers/hospital/hospital_consultant_management_controller.dart';

class HospitalConsultantManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalConsultantManagementController>(
      () => HospitalConsultantManagementController(),
    );
  }
}
