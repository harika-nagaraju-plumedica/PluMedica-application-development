import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_orders_controller.dart';

class PharmacyOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacyOrdersController>(
      () => PharmacyOrdersController(),
    );
  }
}
