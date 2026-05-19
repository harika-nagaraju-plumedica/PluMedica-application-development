import 'package:get/get.dart';
import '../../services/api_exception.dart';
import '../../services/auth_service.dart';
import '../../services/patient_session_service.dart';

class PharmacyLoginController extends GetxController {
  final _authService = AuthService();
  final email = RxString('');
  final password = RxString('');
  final isLoading = RxBool(false);

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
  }

  Future<void> _loadRegisteredEmail() async {
    final lastIdentifier = await PatientSessionService.getRoleLoginIdentifier(
      AppRole.pharmacy,
    );
    if (lastIdentifier.isNotEmpty) {
      email.value = lastIdentifier;
      return;
    }

    final registeredEmail = await PatientSessionService.getRoleEmail(
      AppRole.pharmacy,
    );
    if (registeredEmail.isNotEmpty) {
      email.value = registeredEmail;
    }
  }

  Future<void> login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

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

      Get.snackbar(
        'Success',
        'Login successful',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAllNamed(loginResult.dashboardRoute);
      });
    } on ApiException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while logging in. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    Get.toNamed(
      '/auth/forgot-password',
      arguments: {
        'moduleName': 'Pharmacy',
        'loginRoute': '/pharmacy/login',
        'registeredEmail': email.value.trim(),
      },
    );
  }

  @override
  void onClose() {
    email.value = '';
    password.value = '';
    super.onClose();
  }
}
