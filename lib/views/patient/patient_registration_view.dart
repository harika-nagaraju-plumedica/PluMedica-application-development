import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_registration_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_dropdown.dart';

class PatientRegistrationView extends GetView<PatientRegistrationController> {
  const PatientRegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Patient Registration',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Your Account',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Text(
                      'Please provide your details to register',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      onChanged: (val) => controller.fullName.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Mobile Number',
                      hint: 'Enter your mobile number',
                      keyboardType: TextInputType.phone,
                      onChanged: (val) => controller.mobileNumber.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppDropdown(
                        label: 'Gender',
                        hint: 'Select gender',
                        value: controller.gender.value.isEmpty ? null : controller.gender.value,
                        items: const ['Male', 'Female', 'Other'],
                        onChanged: (val) => controller.gender.value = val ?? '',
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppDropdown(
                        label: 'Blood Group',
                        hint: 'Select blood group',
                        value: controller.bloodGroup.value.isEmpty ? null : controller.bloodGroup.value,
                        items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                        onChanged: (val) => controller.bloodGroup.value = val ?? '',
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Address',
                      hint: 'Enter your address',
                      maxLines: 3,
                      onChanged: (val) => controller.address.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    AppButton(
                      text: 'Register',
                      onPressed: controller.register,
                      width: double.infinity,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Center(
                      child: GestureDetector(
                        onTap: () => Get.toNamed('/patient/login'),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have account? ',
                            style: AppFonts.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                            ],
                          ),
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
