import 'package:get/get.dart';
import '../../controllers/partner/partner_controllers.dart';

class PartnerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerRegistrationController>(
      () => PartnerRegistrationController(),
    );
  }
}

class PartnerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerLoginController>(
      () => PartnerLoginController(),
    );
  }
}

class PartnerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerDashboardController>(
      () => PartnerDashboardController(),
    );
  }
}

class PartnerPoliciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerPoliciesController>(
      () => PartnerPoliciesController(),
    );
  }
}

class PartnerClaimsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerClaimsController>(
      () => PartnerClaimsController(),
    );
  }
}

class PartnerNetworkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerNetworkController>(
      () => PartnerNetworkController(),
    );
  }
}

class PartnerReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PartnerReportsController>(
      () => PartnerReportsController(),
    );
  }
}
