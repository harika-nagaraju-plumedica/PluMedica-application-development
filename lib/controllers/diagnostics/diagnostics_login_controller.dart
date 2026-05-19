import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_exception.dart';
import '../../services/auth_service.dart';
import '../../services/patient_session_service.dart';

class DiagnosticsLoginController extends GetxController {
  final _authService = AuthService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final showPassword = false.obs;
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadRegisteredEmail();
  }

  Future<void> _loadRegisteredEmail() async {
    final lastIdentifier = await PatientSessionService.getRoleLoginIdentifier(
      AppRole.diagnostics,
    );
    if (lastIdentifier.isNotEmpty) {
      emailController.text = lastIdentifier;
      return;
    }

    final registeredEmail = await PatientSessionService.getRoleEmail(
      AppRole.diagnostics,
    );
    if (registeredEmail.isNotEmpty) {
      emailController.text = registeredEmail;
    }
  }

  String? validateIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or ID is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
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

  void navigateToRegistration() {
    Get.toNamed('/diagnostics/registration');
  }

  void forgotPassword() {
    Get.toNamed(
      '/auth/forgot-password',
      arguments: {
        'moduleName': 'Diagnostics',
        'loginRoute': '/diagnostics/login',
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
