import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/patient_session_service.dart';

class DiagnosticsRegistrationController extends GetxController {
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
      await Future<void>.delayed(const Duration(milliseconds: 900));

      await PatientSessionService.markRoleRegistered(
        AppRole.diagnostics,
        email: emailController.text.trim(),
      );

      Get.snackbar(
        'Registration Complete',
        'Please login to continue.',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/diagnostics/login');
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
