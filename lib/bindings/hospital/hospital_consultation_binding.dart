import 'package:get/get.dart';
import '../../controllers/hospital/hospital_consultation_controller.dart';

class HospitalConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalConsultationController>(
      () => HospitalConsultationController(),
    );
  }
}
