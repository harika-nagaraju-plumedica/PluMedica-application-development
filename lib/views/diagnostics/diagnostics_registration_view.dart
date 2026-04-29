import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_registration_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class DiagnosticsRegistrationView
    extends GetView<DiagnosticsRegistrationController> {
  const DiagnosticsRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Diagnostics Registration'),
        backgroundColor: AppColors.primaryDarkBlue,
        foregroundColor: AppColors.white,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register Diagnostics Center',
                  style: AppFonts.heading2.copyWith(
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Create your diagnostics account to continue.',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: 'Center Name',
                  hint: 'Enter diagnostics center name',
                  controller: controller.labNameController,
                  required: true,
                  validator: controller.validateLabName,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Email',
                  hint: 'Enter diagnostics email',
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  required: true,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Password',
                  hint: 'Create password',
                  controller: controller.passwordController,
                  obscureText: !controller.showPassword.value,
                  required: true,
                  validator: controller.validatePassword,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter password',
                  controller: controller.confirmPasswordController,
                  obscureText: !controller.showConfirmPassword.value,
                  required: true,
                  validator: controller.validateConfirmPassword,
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Register',
                  onPressed: controller.submitRegistration,
                  isLoading: controller.isLoading.value,
                  width: double.infinity,
                  backgroundColor: AppColors.primaryDarkBlue,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: controller.navigateToLogin,
                    child: const Text('Already registered? Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
