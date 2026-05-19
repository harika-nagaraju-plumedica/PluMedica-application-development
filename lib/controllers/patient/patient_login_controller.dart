import 'package:get/get.dart';
import '../../services/api_exception.dart';
import '../../services/auth_service.dart';
import '../../services/patient_session_service.dart';

class PatientLoginController extends GetxController {
  final _authService = AuthService();
  final isLoading = false.obs;
  final email = 'rajesh.kumar@email.com'.obs;
  final password = 'demo123'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredUser();
    password.value = 'demo123';
  }

  Future<void> _loadRegisteredUser() async {
    final lastIdentifier = await PatientSessionService.getRoleLoginIdentifier(
      AppRole.patient,
    );
    if (lastIdentifier.isNotEmpty) {
      email.value = lastIdentifier;
      return;
    }

    final registeredEmail = await PatientSessionService.getRegisteredEmail();
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    } else {
      email.value = 'rajesh.kumar@email.com';
    }
  }

  Future<void> login() async {
    if (email.value.trim().isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Please enter both email and password');
      return;
    }

    isLoading.value = true;
    try {
      final loginResult = await _authService.login(
        identifier: email.value.trim(),
        password: password.value,
      );

      if (!loginResult.isApproved) {
        Get.offAllNamed(
          '/pending-verification',
          arguments: {
            'registrationType': loginResult.module,
            'userEmail': email.value.trim(),
          },
        );
        return;
      }

      Get.offAllNamed(loginResult.dashboardRoute);
    } on ApiException catch (e) {
      Get.snackbar('Login Failed', e.message);
    } catch (e) {
      Get.snackbar('Error', 'Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgotPassword() async {
    Get.toNamed(
      '/auth/forgot-password',
      arguments: {
        'moduleName': 'Patient',
        'loginRoute': '/patient/login',
        'registeredEmail': email.value.trim(),
      },
    );
  }
}
