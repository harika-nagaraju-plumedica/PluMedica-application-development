import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_profile_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_dropdown.dart';

class PatientProfileView extends GetView<PatientProfileController> {
  const PatientProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditing.value
                    ? Icons.check
                    : Icons.edit,
              ),
              onPressed: controller.isEditing.value
                  ? controller.saveProfile
                  : controller.editProfile,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primaryBlue,
                            child: const Icon(
                              Icons.person,
                              color: AppColors.white,
                              size: 60,
                            ),
                          ),
                          const SizedBox(height: AppConstants.paddingMedium),
                          Text(
                            controller.fullName.value,
                            style: AppFonts.heading2.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Personal Information',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Full Name',
                      hint: 'Enter full name',
                      readOnly: !controller.isEditing.value,
                      initialValue: controller.fullName.value,
                      onChanged: (val) => controller.fullName.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Email',
                      hint: 'Enter email',
                      readOnly: !controller.isEditing.value,
                      initialValue: controller.email.value,
                      onChanged: (val) => controller.email.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Mobile Number',
                      hint: 'Enter mobile number',
                      readOnly: !controller.isEditing.value,
                      initialValue: controller.mobileNumber.value,
                      onChanged: (val) =>
                          controller.mobileNumber.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Date of Birth',
                      hint: 'DD/MM/YYYY',
                      readOnly: !controller.isEditing.value,
                      initialValue: controller.dateOfBirth.value,
                      onChanged: (val) =>
                          controller.dateOfBirth.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppDropdown(
                        label: 'Gender',
                        hint: 'Select gender',
                        value: controller.gender.value.isEmpty ? null : controller.gender.value,
                        items: const ['Male', 'Female', 'Other'],
                        onChanged: controller.isEditing.value
                            ? (val) => controller.gender.value = val ?? ''
                            : (_) {},
                        enabled: controller.isEditing.value,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    Obx(
                      () => AppDropdown(
                        label: 'Blood Group',
                        hint: 'Select blood group',
                        value: controller.bloodGroup.value.isEmpty ? null : controller.bloodGroup.value,
                        items: const ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                        onChanged: controller.isEditing.value
                            ? (val) => controller.bloodGroup.value = val ?? ''
                            : (_) {},
                        enabled: controller.isEditing.value,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    AppTextField(
                      label: 'Address',
                      hint: 'Enter address',
                      readOnly: !controller.isEditing.value,
                      maxLines: 3,
                      initialValue: controller.address.value,
                      onChanged: (val) => controller.address.value = val,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Security',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: controller.changePassword,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryBlue,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium,
                          ),
                        ),
                        child: const Text('Change Password'),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.logOut,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium,
                          ),
                        ),
                        child: const Text('Logout'),
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: controller.deleteAccount,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.error,
                          side: const BorderSide(color: AppColors.error),
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium,
                          ),
                        ),
                        child: const Text('Delete Account'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
