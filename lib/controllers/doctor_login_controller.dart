import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import '../services/patient_session_service.dart';

/// Controller for doctor login flow
class DoctorLoginController extends GetxController {
  final _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final showPassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
  }

  Future<void> _loadRegisteredEmail() async {
    final lastIdentifier = await PatientSessionService.getRoleLoginIdentifier(
      AppRole.doctor,
    );
    if (lastIdentifier.isNotEmpty) {
      emailController.text = lastIdentifier;
      return;
    }

    final registeredEmail = await PatientSessionService.getRoleEmail(
      AppRole.doctor,
    );
    if (registeredEmail.isNotEmpty) {
      emailController.text = registeredEmail;
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  /// Validate email or generated ID
  String? validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or ID is required';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Perform login
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final loginResult = await _authService.login(
        identifier: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!loginResult.isApproved) {
        Get.offAllNamed(
          '/pending-verification',
          arguments: {
            'registrationType': loginResult.module,
            'userEmail': emailController.text.trim(),
          },
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      Get.offAllNamed(loginResult.dashboardRoute);
    } on ApiException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate to registration
  void navigateToRegistration() {
    Get.toNamed('/doctor_registration');
  }

  /// Handle forgot password
  void forgotPassword() {
    Get.toNamed(
      '/auth/forgot-password',
      arguments: {
        'moduleName': 'Doctor',
        'loginRoute': '/doctor_login',
        'registeredEmail': emailController.text.trim(),
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
