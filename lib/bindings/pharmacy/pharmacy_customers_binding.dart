import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_customers_controller.dart';

class PharmacyCustomersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyCustomersController>(
      () => PharmacyCustomersController(),
    );
  }
}
