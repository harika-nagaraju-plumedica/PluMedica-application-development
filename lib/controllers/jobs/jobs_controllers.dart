import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class JobSeekerRegistrationController extends GetxController {
  final isLoading = false.obs;
  final fullName = 'John Seeker'.obs;
  final email = 'john.seeker@email.com'.obs;
  final phone = '+91-9876543210'.obs;
  final experience = '3 years'.obs;
  final skills = ['Flutter', 'Dart', 'Firebase'].obs;

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
    loadDemoData();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.jobSeeker);
    if (isRegistered) {
      Get.offAllNamed('/jobs/job-seeker/login');
    }
  }

  void loadDemoData() {
    fullName.value = 'John Seeker';
    email.value = 'john.seeker@email.com';
    phone.value = '+91-9876543210';
    experience.value = '3 years';
    skills.value = ['Flutter', 'Dart', 'Firebase'];
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.jobSeeker,
        email: email.value,
      );
      Get.offAllNamed('/jobs/search');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> skipToDemo() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/jobs/job-seeker/search');
    } catch (e) {
      Get.snackbar('Error', 'Navigation failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class JobSeekerLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'john.seeker@email.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
    password.value = 'demo123';
  }

  Future<void> _loadRegisteredEmail() async {
    final registeredEmail = await PatientSessionService.getRoleEmail(AppRole.jobSeeker);
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    } else {
      email.value = 'john.seeker@email.com';
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.jobSeeker,
        email: email.value,
      );
      Get.offAllNamed('/jobs/search');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class JobSearchController extends GetxController {
  final isLoading = false.obs;
  final jobs = <Map<String, dynamic>>[].obs;
  final searchQuery = ''.obs;

  Future<void> loadJobs() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      jobs.value = [
        {
          'id': 'JOB001',
          'title': 'Flutter Developer',
          'company': 'Tech Solutions Inc',
          'location': 'Bangalore',
          'salary': '8-12 LPA',
          'experience': '3-5 years',
          'type': 'Full-time'
        },
        {
          'id': 'JOB002',
          'title': 'Senior Flutter Developer',
          'company': 'Innovation Labs',
          'location': 'Hyderabad',
          'salary': '12-16 LPA',
          'experience': '5-7 years',
          'type': 'Full-time'
        },
        {
          'id': 'JOB003',
          'title': 'Mobile App Developer',
          'company': 'Digital Ventures',
          'location': 'Mumbai',
          'salary': '6-10 LPA',
          'experience': '2-3 years',
          'type': 'Full-time'
        },
        {
          'id': 'JOB004',
          'title': 'Flutter Intern',
          'company': 'Startup Hub',
          'location': 'Remote',
          'salary': '3-5 LPA',
          'experience': '0-1 years',
          'type': 'Internship'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load jobs');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadJobs();
  }
}

class JobListingController extends GetxController {
  final isLoading = false.obs;
  final jobListings = [].obs;
  @override
  void onInit() {
    super.onInit();
    loadJobListings();
  }

  Future<void> loadJobListings() async {
    isLoading.value = true;
    try {
      // TODO: Fetch job listings
    } catch (e) {
      Get.snackbar('Error', 'Failed to load listings');
    } finally {
      isLoading.value = false;
    }
  }
}

class JobDetailController extends GetxController {
  final isLoading = false.obs;
  final job = Rx<dynamic>(null);
  Future<void> applyForJob() async {
    // TODO: Submit application
  }
}

class ApplicationStatusController extends GetxController {
  final isLoading = false.obs;
  final applications = [].obs;
  @override
  void onInit() {
    super.onInit();
    loadApplications();
  }

  Future<void> loadApplications() async {
    isLoading.value = true;
    try {
      // TODO: Fetch applications
    } catch (e) {
      Get.snackbar('Error', 'Failed to load applications');
    } finally {
      isLoading.value = false;
    }
  }
}

class EmployerRegistrationController extends GetxController {
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.employer);
    if (isRegistered) {
      Get.offAllNamed('/jobs/employer/login');
    }
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      await PatientSessionService.markRoleLoggedIn(AppRole.employer);
      Get.offAllNamed('/jobs/employer/post-job');
    } catch (e) {
      Get.snackbar('Error', 'Registration failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class EmployerLoginController extends GetxController {
  final isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;
    try {
      await PatientSessionService.markRoleLoggedIn(AppRole.employer);
      Get.offAllNamed('/jobs/employer/post-job');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class JobPostingCreationController extends GetxController {
  final isLoading = false.obs;

  Future<void> logout() async {
    await PatientSessionService.logoutRole(AppRole.employer);
    Get.offAllNamed('/role_selection');
  }

  Future<void> post() async {
    isLoading.value = true;
    try {
      // TODO: Post job
      Get.snackbar('Success', 'Job posted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to post job');
    } finally {
      isLoading.value = false;
    }
  }
}

class CandidateListController extends GetxController {
  final isLoading = false.obs;
  final candidates = [].obs;
  @override
  void onInit() {
    super.onInit();
    loadCandidates();
  }

  Future<void> loadCandidates() async {
    isLoading.value = true;
    try {
      // TODO: Fetch candidates
    } catch (e) {
      Get.snackbar('Error', 'Failed to load candidates');
    } finally {
      isLoading.value = false;
    }
  }
}

class CandidateDetailController extends GetxController {
  final isLoading = false.obs;
  final candidate = Rx<dynamic>(null);
  Future<void> updateStatus(String status) async {
    // TODO: Update candidate status
  }
}
