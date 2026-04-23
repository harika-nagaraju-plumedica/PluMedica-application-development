import 'package:get/get.dart';
import '../../controllers/jobs/jobs_controllers.dart';

class JobSeekerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSeekerRegistrationController>(
      () => JobSeekerRegistrationController(),
    );
  }
}

class JobSeekerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSeekerLoginController>(
      () => JobSeekerLoginController(),
    );
  }
}

class JobSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobSearchController>(
      () => JobSearchController(),
    );
  }
}

class JobListingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobListingController>(
      () => JobListingController(),
    );
  }
}

class JobDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobDetailController>(
      () => JobDetailController(),
    );
  }
}

class ApplicationStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApplicationStatusController>(
      () => ApplicationStatusController(),
    );
  }
}

class EmployerRegistrationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerRegistrationController>(
      () => EmployerRegistrationController(),
    );
  }
}

class EmployerLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmployerLoginController>(
      () => EmployerLoginController(),
    );
  }
}

class JobPostingCreationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobPostingCreationController>(
      () => JobPostingCreationController(),
    );
  }
}

class CandidateListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidateListController>(
      () => CandidateListController(),
    );
  }
}

class CandidateDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CandidateDetailController>(
      () => CandidateDetailController(),
    );
  }
}
