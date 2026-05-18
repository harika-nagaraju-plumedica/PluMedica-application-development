import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_exception.dart';
import '../../services/registration_service.dart';
import '../../services/patient_session_service.dart';

class DiagnosticsRegistrationController extends GetxController {
  final _registrationService = RegistrationService();

  final labNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final showPassword = false.obs;
  final showConfirmPassword = false.obs;
  final formKey = GlobalKey<FormState>();

  String? validateLabName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Diagnostics center name is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    const pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
    if (!RegExp(pattern).hasMatch(value.trim())) {
      return 'Enter a valid email address';
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  Future<void> submitRegistration() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      final response = await _registrationService.registerDiagnosticsCenter(
        centerName: labNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await PatientSessionService.markRoleRegistered(
        AppRole.diagnostics,
        email: emailController.text.trim(),
        displayName: labNameController.text.trim(),
      );

      Get.snackbar(
        'Registration Complete',
        response.message.isEmpty ? 'Please login to continue.' : response.message,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/diagnostics/login');
    } on ApiException catch (e) {
      Get.snackbar('Registration Failed', e.message);
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() {
    Get.toNamed('/diagnostics/login');
  }

  @override
  void onClose() {
    labNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
