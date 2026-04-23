import 'package:get/get.dart';
import '../../controllers/hospital/hospital_payment_summary_controller.dart';

class HospitalPaymentSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HospitalPaymentSummaryController>(
      () => HospitalPaymentSummaryController(),
    );
  }
}
