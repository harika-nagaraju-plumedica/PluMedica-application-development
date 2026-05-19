import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_login_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class PatientLoginView extends GetView<PatientLoginController> {
  const PatientLoginView({super.key});

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
                    Container(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusLarge),
                      ),
                      child: Center(
                        child: Text(
                          'Plumedica',
                          style: AppFonts.heading1.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Patient Login',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Sign in to access your health records',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppTextField(
                      label: 'Email or ID',
                      hint: 'Enter your email or generated ID',
                      keyboardType: TextInputType.text,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      obscureText: true,
                      onChanged: (val) => controller.password.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: controller.forgotPassword,
                        child: Text(
                          'Forgot Password?',
                          style: AppFonts.bodyMedium.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Login',
                      onPressed: controller.login,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
