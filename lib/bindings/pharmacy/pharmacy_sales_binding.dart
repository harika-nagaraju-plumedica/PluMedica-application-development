import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_sales_controller.dart';

class PharmacySalesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PharmacySalesController>(
      () => PharmacySalesController(),
    );
  }
}
