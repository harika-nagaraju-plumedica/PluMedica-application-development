import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_login_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class DiagnosticsLoginView extends GetView<DiagnosticsLoginController> {
  const DiagnosticsLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Diagnostics Login'),
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
                  'Welcome Back',
                  style: AppFonts.heading2.copyWith(
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Login to access your diagnostics dashboard.',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
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
                  hint: 'Enter password',
                  controller: controller.passwordController,
                  obscureText: !controller.showPassword.value,
                  required: true,
                  validator: controller.validatePassword,
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Login',
                  onPressed: controller.login,
                  isLoading: controller.isLoading.value,
                  width: double.infinity,
                  backgroundColor: AppColors.primaryDarkBlue,
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: controller.navigateToRegistration,
                    child: const Text('New diagnostics center? Register'),
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
