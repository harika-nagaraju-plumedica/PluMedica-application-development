import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for doctor login flow
class DoctorLoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final showPassword = false.obs;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
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
      // TODO: API call to authenticate doctor
      // Simulate network call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Store authentication token
      Get.snackbar(
        'Success',
        'Logged in successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Navigate to doctor dashboard
      Get.offNamed('/doctor_dashboard');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to login: ${e.toString()}',
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
    // TODO: Implement forgot password flow
    Get.snackbar(
      'Info',
      'Password reset link sent to your email',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
