import 'package:get/get.dart';

import '../controllers/doctor_referral_notifications_controller.dart';

class DoctorReferralNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorReferralNotificationsController>(
      () => DoctorReferralNotificationsController(),
      fenix: true,
    );
  }
}
