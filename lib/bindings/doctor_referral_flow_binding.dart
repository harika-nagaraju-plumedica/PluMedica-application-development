import 'package:get/get.dart';

import '../controllers/doctor_referral_flow_controller.dart';

class DoctorReferralFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorReferralFlowController>(
      () => DoctorReferralFlowController(),
      fenix: true,
    );
  }
}
