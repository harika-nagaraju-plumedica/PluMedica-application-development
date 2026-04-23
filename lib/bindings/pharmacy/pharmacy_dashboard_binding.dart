import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_dashboard_controller.dart';

class PharmacyDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyDashboardController>(
      () => PharmacyDashboardController(),
    );
  }
}
