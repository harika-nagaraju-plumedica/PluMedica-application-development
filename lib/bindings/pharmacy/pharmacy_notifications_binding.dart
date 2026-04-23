import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_notifications_controller.dart';

class PharmacyNotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyNotificationsController>(
      () => PharmacyNotificationsController(),
    );
  }
}
