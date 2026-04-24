import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PartnerRegistrationController extends GetxController {
  final isLoading = false.obs;
  final companyName = 'Health Insurance Co.'.obs;
  final registrationNumber = 'INSURE-2024-001'.obs;
  final email = 'admin@healthinsurance.com'.obs;
  final phone = '+91-9876543210'.obs;
  final licenseNumber = 'LIC-2024-UIN-001'.obs;
  final address = '456 Insurance Plaza, Financial District, Metro City'.obs;

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
    loadDemoData();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.partner);
    if (isRegistered) {
      Get.offAllNamed('/partner/login');
    }
  }

  void loadDemoData() {
    companyName.value = 'Health Insurance Co.';
    registrationNumber.value = 'INSURE-2024-001';
    email.value = 'admin@healthinsurance.com';
    phone.value = '+91-9876543210';
    licenseNumber.value = 'LIC-2024-UIN-001';
    address.value = '456 Insurance Plaza, Financial District, Metro City';
  }

  Future<void> register() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.partner,
        email: email.value,
      );
      Get.offAllNamed('/partner/dashboard');
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
      Get.offNamed('/partner/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Navigation failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class PartnerLoginController extends GetxController {
  final isLoading = false.obs;
  final email = 'admin@healthinsurance.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
    password.value = 'demo123';
  }

  Future<void> _loadRegisteredEmail() async {
    final registeredEmail = await PatientSessionService.getRoleEmail(AppRole.partner);
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    } else {
      email.value = 'admin@healthinsurance.com';
    }
  }

  Future<void> login() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.partner,
        email: email.value,
      );
      Get.offAllNamed('/partner/dashboard');
    } catch (e) {
      Get.snackbar('Error', 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }
}

class PartnerDashboardController extends GetxController {
  final isLoading = false.obs;
  final partnerName = 'Health Insurance Co.'.obs;
  final totalMembers = 5000.obs;
  final activeClaims = 25.obs;
  final totalRevenue = 125000000.0.obs;
  final claimsPending = 8.obs;
  final networkHospitals = 250.obs;

  final policies = <Map<String, dynamic>>[].obs;
  final recentClaims = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      policies.value = [
        {
          'id': 'POL001',
          'name': 'Premium Health Cover',
          'premium': 5000,
          'coverage': 500000,
          'members': 2000,
          'status': 'Active'
        },
        {
          'id': 'POL002',
          'name': 'Family Health Plus',
          'premium': 8000,
          'coverage': 1000000,
          'members': 2500,
          'status': 'Active'
        },
        {
          'id': 'POL003',
          'name': 'Corporate Health',
          'premium': 3000,
          'coverage': 300000,
          'members': 500,
          'status': 'Active'
        },
      ];

      recentClaims.value = [
        {
          'id': 'CLM001',
          'policyId': 'POL001',
          'claimant': 'Rajesh Kumar',
          'amount': 50000,
          'status': 'Approved',
          'date': '2026-04-16'
        },
        {
          'id': 'CLM002',
          'policyId': 'POL002',
          'claimant': 'Priya Sharma',
          'amount': 120000,
          'status': 'Under Review',
          'date': '2026-04-15'
        },
        {
          'id': 'CLM003',
          'policyId': 'POL001',
          'claimant': 'Amit Patel',
          'amount': 75000,
          'status': 'Pending',
          'date': '2026-04-14'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> navigateToPolicies() async {
    Get.toNamed('/partner/policies');
  }

  Future<void> navigateToClaims() async {
    Get.toNamed('/partner/claims');
  }

  Future<void> navigateToNetwork() async {
    Get.toNamed('/partner/network');
  }

  Future<void> navigateToReports() async {
    Get.toNamed('/partner/reports');
  }

  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  Future<void> logout() async {
    await PatientSessionService.logoutRole(AppRole.partner);
    Get.offAllNamed('/role_selection');
  }
}

class PartnerPoliciesController extends GetxController {
  final isLoading = false.obs;
  final policies = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPolicies();
  }

  Future<void> loadPolicies() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      policies.value = [
        {
          'id': 'POL001',
          'name': 'Premium Health Cover',
          'premium': 5000,
          'coverage': 500000,
          'members': 2000,
          'status': 'Active',
          'features': ['OPD', 'IPD', 'Maternity', 'Critical Illness']
        },
        {
          'id': 'POL002',
          'name': 'Family Health Plus',
          'premium': 8000,
          'coverage': 1000000,
          'members': 2500,
          'status': 'Active',
          'features': ['OPD', 'IPD', 'Maternity', 'Wellness']
        },
        {
          'id': 'POL003',
          'name': 'Corporate Health',
          'premium': 3000,
          'coverage': 300000,
          'members': 500,
          'status': 'Active',
          'features': ['OPD', 'IPD', 'Employee Wellness']
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load policies');
    } finally {
      isLoading.value = false;
    }
  }
}

class PartnerClaimsController extends GetxController {
  final isLoading = false.obs;
  final claims = <Map<String, dynamic>>[].obs;
  final totalClaims = 150.obs;
  final approvedClaims = 110.obs;
  final pendingClaims = 25.obs;
  final rejectedClaims = 15.obs;

  @override
  void onInit() {
    super.onInit();
    loadClaims();
  }

  Future<void> loadClaims() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      claims.value = [
        {
          'id': 'CLM001',
          'claimant': 'Rajesh Kumar',
          'policyId': 'POL001',
          'amount': 50000,
          'status': 'Approved',
          'date': '2026-04-16',
          'hospital': 'City Medical Centre'
        },
        {
          'id': 'CLM002',
          'claimant': 'Priya Sharma',
          'policyId': 'POL002',
          'amount': 120000,
          'status': 'Under Review',
          'date': '2026-04-15',
          'hospital': 'Metro Hospital'
        },
        {
          'id': 'CLM003',
          'claimant': 'Amit Patel',
          'policyId': 'POL001',
          'amount': 75000,
          'status': 'Pending',
          'date': '2026-04-14',
          'hospital': 'Apollo Medical'
        },
        {
          'id': 'CLM004',
          'claimant': 'Sarah Johnson',
          'policyId': 'POL002',
          'amount': 95000,
          'status': 'Approved',
          'date': '2026-04-13',
          'hospital': 'Care Hospital'
        },
        {
          'id': 'CLM005',
          'claimant': 'John Doe',
          'policyId': 'POL003',
          'amount': 35000,
          'status': 'Approved',
          'date': '2026-04-12',
          'hospital': 'City Medical Centre'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load claims');
    } finally {
      isLoading.value = false;
    }
  }
}

class PartnerNetworkController extends GetxController {
  final isLoading = false.obs;
  final hospitals = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHospitals();
  }

  Future<void> loadHospitals() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      hospitals.value = [
        {
          'id': 'HOSP001',
          'name': 'City Medical Centre',
          'city': 'Metro City',
          'beds': 200,
          'doctors': 45,
          'rating': 4.8,
          'specialties': ['Cardiology', 'Neurology', 'Orthopedics'],
          'networkType': 'Premium'
        },
        {
          'id': 'HOSP002',
          'name': 'Apollo Medical',
          'city': 'Downtown',
          'beds': 350,
          'doctors': 78,
          'rating': 4.9,
          'specialties': ['Cardiology', 'Oncology', 'Surgery'],
          'networkType': 'Premium'
        },
        {
          'id': 'HOSP003',
          'name': 'Care Hospital',
          'city': 'Suburbs',
          'beds': 150,
          'doctors': 32,
          'rating': 4.5,
          'specialties': ['General Medicine', 'Pediatrics'],
          'networkType': 'Standard'
        },
        {
          'id': 'HOSP004',
          'name': 'Metro Hospital',
          'city': 'Central District',
          'beds': 280,
          'doctors': 65,
          'rating': 4.7,
          'specialties': ['Cardiology', 'Neurology', 'Psychiatry'],
          'networkType': 'Premium'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load hospitals');
    } finally {
      isLoading.value = false;
    }
  }
}

class PartnerReportsController extends GetxController {
  final isLoading = false.obs;
  final reports = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  Future<void> loadReports() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      reports.value = [
        {
          'id': 'RPT001',
          'title': 'Monthly Claims Report',
          'period': 'April 2026',
          'totalClaims': 150,
          'totalAmount': 12500000,
          'generatedDate': '2026-04-17',
          'status': 'Available'
        },
        {
          'id': 'RPT002',
          'title': 'Policy Performance Report',
          'period': 'Q1 2026',
          'activeMembers': 5000,
          'premiumCollected': 125000000,
          'generatedDate': '2026-04-10',
          'status': 'Available'
        },
        {
          'id': 'RPT003',
          'title': 'Network Utilization Report',
          'period': 'April 2026',
          'networkHospitals': 250,
          'referrals': 320,
          'generatedDate': '2026-04-15',
          'status': 'Available'
        },
        {
          'id': 'RPT004',
          'title': 'Member Feedback Report',
          'period': 'April 2026',
          'responseRate': 65,
          'averageRating': 4.6,
          'generatedDate': '2026-04-17',
          'status': 'Available'
        },
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reports');
    } finally {
      isLoading.value = false;
    }
  }
}
