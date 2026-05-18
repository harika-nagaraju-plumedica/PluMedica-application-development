import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacy/pharmacy_login_controller.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class PharmacyLoginView extends GetView<PharmacyLoginController> {
  const PharmacyLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 60),
                    // Pharmacy Portal Header
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                        border: Border.all(
                          color: AppColors.green.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.local_pharmacy,
                            color: AppColors.green,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Pharmacy Portal',
                              style: AppFonts.heading1.copyWith(
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Login Heading
                    Text(
                      'Pharmacy Login',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access your pharmacy account',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXLarge),

                    // Email Field
                    AppTextField(
                      label: 'Email Address',
                      hint: 'Enter pharmacy email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),

                    // Password Field
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      onChanged: (val) => controller.password.value = val,
                    ),
                    const SizedBox(height: 12),

                    // Forgot Password Link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: controller.forgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXLarge),

                    // Login Button
                    Obx(
                      () => AppButton(
                        text: 'Login',
                        onPressed: controller.login,
                        width: double.infinity,
                        height: 50,
                        backgroundColor: AppColors.green,
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Info Box
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusMedium,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.success,
                            size: 24,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Demo Credentials',
                            style: AppFonts.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Email: pharmacy@plumedica.com\nPassword: password123',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
