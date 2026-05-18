import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_login_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class HospitalLoginView extends GetView<HospitalLoginController> {
  const HospitalLoginView({super.key});

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
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                      ),
                      child: Center(
                        child: Text(
                          'Hospital Portal',
                          style: AppFonts.heading1.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'Hospital Login',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter hospital email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Password',
                      hint: 'Enter password',
                      obscureText: true,
                      onChanged: (val) => controller.password.value = val,
                    ),
                    const SizedBox(height: 12),
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
