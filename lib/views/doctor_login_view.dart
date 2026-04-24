import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_login_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

/// Doctor Login View
class DoctorLoginView extends GetView<DoctorLoginController> {
  const DoctorLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingLarge,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: AppColors.primaryGradient,
                        ),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).padding.top),
                          const SizedBox(height: 32),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.local_hospital,
                              size: 48,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Doctor Login',
                            style: AppFonts.heading2.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Access your medical dashboard',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),

                    // Form Section
                    Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Form(
                        key: controller.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 24),

                            // Email TextField
                            AppTextField(
                              label: 'Email Address',
                              hint: 'Enter your registered email',
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              required: true,
                              validator: controller.validateEmail,
                            ),
                            const SizedBox(height: 20),

                            // Password TextField
                            AppTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: controller.passwordController,
                              obscureText: !controller.showPassword.value,
                              required: true,
                              validator: controller.validatePassword,
                            ),
                            const SizedBox(height: 12),

                            // Show Password Toggle
                            Obx(
                              () => Align(
                                alignment: Alignment.centerRight,
                                child: GestureDetector(
                                  onTap: controller.togglePasswordVisibility,
                                  child: Text(
                                    controller.showPassword.value
                                        ? 'Hide Password'
                                        : 'Show Password',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Login Button
                            Obx(
                              () => AppButton(
                                text: 'Login',
                                onPressed: controller.login,
                                isLoading: controller.isLoading.value,
                                width: double.infinity,
                                height: 50,
                                backgroundColor: AppColors.primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Forgot Password
                            Center(
                              child: GestureDetector(
                                onTap: controller.forgotPassword,
                                child: Text(
                                  'Forgot Password?',
                                  style: AppFonts.bodySmall.copyWith(
                                    color: AppColors.primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Info Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(
                                AppConstants.paddingMedium,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shield,
                                        color: AppColors.success,
                                        size: AppConstants.iconSizeMedium,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'Secure & Verified Login',
                                          style: AppFonts.labelLarge.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Your credentials are encrypted and securely stored. Patient data is protected under medical confidentiality standards.',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
