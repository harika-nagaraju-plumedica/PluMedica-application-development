import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/patient_session_service.dart';

class DiagnosticsLoginController extends GetxController {
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
    final registeredEmail = await PatientSessionService.getRoleEmail(
      AppRole.diagnostics,
    );
    if (registeredEmail.isNotEmpty) {
      emailController.text = registeredEmail;
    }
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

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));

      await PatientSessionService.markRoleLoggedIn(
        AppRole.diagnostics,
        email: emailController.text.trim(),
      );

      Get.offAllNamed('/diagnostics/dashboard');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegistration() {
    Get.toNamed('/diagnostics/registration');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
