import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_registration_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

/// Doctor Registration View
class DoctorRegistrationView extends GetView<DoctorRegistrationController> {
  const DoctorRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Doctor Registration'),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Form(
                    key: controller.registrationFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.paddingMedium,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Professional Information',
                                style: AppFonts.heading2.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Please provide your professional details for verification',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Status: ${controller.registrationStatus.value}',
                                  style: AppFonts.bodySmall.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Full Name
                        AppTextField(
                          label: 'Full Name',
                          hint: 'Enter your full name',
                          controller: controller.fullNameController,
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Email
                        AppTextField(
                          label: 'Email Address',
                          hint: 'Enter your email',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          required: true,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 16),

                        // Mobile Number
                        AppTextField(
                          label: 'Mobile Number',
                          hint: 'Enter 10-digit mobile number',
                          controller: controller.mobileController,
                          keyboardType: TextInputType.phone,
                          required: true,
                          validator: controller.validateMobile,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        AppTextField(
                          label: 'Password',
                          hint: 'Minimum 8 characters',
                          controller: controller.passwordController,
                          obscureText: true,
                          required: true,
                          validator: controller.validatePassword,
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        AppTextField(
                          label: 'Confirm Password',
                          hint: 'Re-enter password',
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          required: true,
                          validator: controller.validateConfirmPassword,
                        ),
                        const SizedBox(height: 16),

                        // Qualification
                        GetBuilder<DoctorRegistrationController>(
                          builder: (ctrl) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                'Select Qualification',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              value: ctrl.qualificationController.text.isEmpty
                                  ? null
                                  : ctrl.qualificationController.text,
                              items: ctrl.qualificationsList
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  ctrl.qualificationController.text = newValue;
                                  ctrl.update();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GetBuilder<DoctorRegistrationController>(
                          builder: (controller) => Text(
                            'Selected: ${controller.qualificationController.text.isEmpty ? 'None' : controller.qualificationController.text}',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Qualification *',
                          style: AppFonts.heading3.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Specialization
                        GetBuilder<DoctorRegistrationController>(
                          builder: (ctrl) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: Text(
                                'Select Specialization',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              value: ctrl.specializationController.text.isEmpty
                                  ? null
                                  : ctrl.specializationController.text,
                              items: ctrl.specializationsList
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  ctrl.specializationController.text = newValue;
                                  ctrl.update();
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        GetBuilder<DoctorRegistrationController>(
                          builder: (controller) => Text(
                            'Selected: ${controller.specializationController.text.isEmpty ? 'None' : controller.specializationController.text}',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Specialization (Optional)',
                          style: AppFonts.heading3.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Year of Graduation
                        AppTextField(
                          label: 'Year of Graduation',
                          hint: 'Enter graduation year (e.g. 2016)',
                          controller: controller.graduationYearController,
                          keyboardType: TextInputType.number,
                          required: true,
                          validator: controller.validateGraduationYear,
                        ),
                        const SizedBox(height: 16),

                        // Years of Experience
                        AppTextField(
                          label: 'Years of Experience',
                          hint: 'Enter years of experience',
                          controller: controller.experienceController,
                          keyboardType: TextInputType.number,
                          required: true,
                          validator: controller.validateExperience,
                        ),
                        const SizedBox(height: 16),

                        // Clinic Address
                        AppTextField(
                          label: 'Clinic Address',
                          hint: 'Enter your clinic address',
                          controller: controller.clinicAddressController,
                          required: true,
                          maxLines: 3,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Clinic address is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Medical License Number
                        AppTextField(
                          label: 'Medical License Number',
                          hint: 'Enter your license number',
                          controller: controller.licenseNumberController,
                          required: true,
                          validator: controller.validateLicense,
                        ),
                        const SizedBox(height: 16),

                        // Medical License Upload
                        Center(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppConstants.paddingMedium),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryBlue,
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                              color: AppColors.primaryBlue.withValues(alpha: 0.05),
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 48,
                                  color: AppColors.primaryBlue,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Medical License Upload (Optional)',
                                  style: AppFonts.heading3.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Obx(
                                  () => Text(
                                    controller.medicalLicenseFileName.value ?? 'Tap to upload file',
                                    style: AppFonts.labelMedium.copyWith(
                                      color: controller.medicalLicenseFileName.value != null
                                          ? AppColors.success
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: controller.uploadMedicalLicense,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue,
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadiusSmall,
                                      ),
                                    ),
                                    child: Text(
                                      'Browse Files',
                                      style: AppFonts.labelLarge.copyWith(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Availability Slots (single-open day accordion)
                        Text(
                          'Availability Slots & Mode *',
                          style: AppFonts.heading2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap a day to edit. Opening a day closes the previous one.',
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Column(
                            children: controller.daysList.map((day) {
                              final isOpen =
                                  controller.expandedAvailabilityDay.value == day;
                              final isSelected =
                                  controller.selectedAvailability.contains(day);
                              final isConfigured =
                                  controller.hasConfiguredAvailability(day);
                              final dayKey = controller.getDaySectionKey(day);

                              return AnimatedContainer(
                              key: dayKey,
                                duration: const Duration(milliseconds: 180),
                                width: double.infinity,
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: isConfigured
                                      ? AppColors.primaryBlue.withValues(alpha: 0.08)
                                      : AppColors.white,
                                  border: Border.all(
                                    color: isOpen || isConfigured
                                        ? AppColors.primaryBlue
                                        : AppColors.lightGrey,
                                    width: isOpen || isConfigured ? 1.4 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusMedium,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadiusMedium,
                                      ),
                                      onTap: () {
                                        final wasOpen =
                                            controller.expandedAvailabilityDay.value ==
                                                day;
                                        controller.toggleAvailabilityPanel(day);

                                        if (!wasOpen) {
                                          WidgetsBinding.instance
                                              .addPostFrameCallback((_) {
                                            final ctx = dayKey.currentContext;
                                            if (ctx != null) {
                                              Scrollable.ensureVisible(
                                                ctx,
                                                duration:
                                                    const Duration(milliseconds: 260),
                                                curve: Curves.easeOutCubic,
                                                alignment: 0.08,
                                              );
                                            }
                                          });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppConstants.paddingMedium,
                                          vertical: AppConstants.paddingSmall,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                day,
                                                style: AppFonts.labelLarge.copyWith(
                                                  color: isOpen || isConfigured
                                                      ? AppColors.primaryBlue
                                                      : AppColors.textPrimary,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            if (isConfigured)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.success
                                                      .withValues(alpha: 0.15),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  'Configured',
                                                  style: AppFonts.labelSmall
                                                      .copyWith(
                                                    color: AppColors.success,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            if (isSelected) const SizedBox(width: 8),
                                            if (isSelected)
                                              GestureDetector(
                                                onTap: () => controller
                                                    .removeAvailabilityDay(day),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: AppColors.textSecondary,
                                                ),
                                              ),
                                            const SizedBox(width: 8),
                                            Icon(
                                              isOpen
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: AppColors.primaryBlue,
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (isOpen)
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          AppConstants.paddingMedium,
                                          0,
                                          AppConstants.paddingMedium,
                                          AppConstants.paddingSmall,
                                        ),
                                        child: Column(
                                          children: [
                                            _buildDropdownField(
                                              hint: 'Select time slot',
                                              value: controller
                                                  .selectedDayTimeSlots[day],
                                              items: controller.timeSlotsList,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  controller.setDayTimeSlot(
                                                    day,
                                                    value,
                                                  );
                                                }
                                              },
                                            ),
                                            const SizedBox(height: 8),
                                            _buildDropdownField(
                                              hint:
                                                  'Select mode (Virtual / In-Person)',
                                              value: controller
                                                      .selectedDayConsultationModes[
                                                  day],
                                              items:
                                                  controller.consultationModesList,
                                              onChanged: (value) {
                                                if (value != null) {
                                                  controller
                                                      .setDayConsultationMode(
                                                    day,
                                                    value,
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => Text(
                            'Configured days: ${controller.selectedAvailability.isEmpty ? 'None' : controller.selectedAvailability.join(', ')}',
                            style: AppFonts.bodySmall.copyWith(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Information Box
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            border: Border.all(
                              color: AppColors.primaryBlue.withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Important Information:',
                                style: AppFonts.heading3.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoPoint(
                                '• Your registration will be marked as "Pending Approval" after submission.',
                              ),
                              _buildInfoPoint(
                                '• Admin will verify your Medical License Number and uploaded document.',
                              ),
                              _buildInfoPoint(
                                '• Your profile will be activated once admin approves your credentials.',
                              ),
                              _buildInfoPoint(
                                '• You will receive approval/rejection updates via email.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Obx(
                          () => AppButton(
                            text: 'Submit for Approval',
                            onPressed: controller.submitRegistration,
                            isLoading: controller.isLoading.value,
                            width: double.infinity,
                            height: 50,
                            backgroundColor: AppColors.primaryDarkBlue,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Login Link
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.toNamed('/doctor_login'),
                            child: RichText(
                              text: TextSpan(
                                text: 'Already registered? ',
                                style: AppFonts.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Login here',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.primaryBlue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppFonts.bodySmall.copyWith(
          color: AppColors.textPrimary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSmall,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.lightGrey,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        iconSize: 20,
        value: value,
        underline: const SizedBox(),
        hint: Text(
          hint,
          style: AppFonts.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        items: items
            .map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

