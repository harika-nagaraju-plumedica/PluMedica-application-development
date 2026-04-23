import 'package:get/get.dart';
import '../../controllers/hospital/hospital_emergency_services_controller.dart';

class HospitalEmergencyServicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalEmergencyServicesController>(
      () => HospitalEmergencyServicesController(),
    );
  }
}
