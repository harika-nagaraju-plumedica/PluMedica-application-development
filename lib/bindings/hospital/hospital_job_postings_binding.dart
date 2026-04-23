import 'package:get/get.dart';
import '../../controllers/hospital/hospital_job_postings_controller.dart';

class HospitalJobPostingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalJobPostingsController>(
      () => HospitalJobPostingsController(),
    );
  }
}
