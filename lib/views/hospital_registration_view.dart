import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/hospital/hospital_registration_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/document_upload_widget.dart';

/// Hospital registration form view - Only change required fields
class HospitalRegistrationView extends GetView<HospitalRegistrationController> {
  const HospitalRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Hospital Registration'),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
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
                                'Hospital Registration',
                                style: AppFonts.heading2.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please provide your hospital details for verification',
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
                                  color: AppColors.warning.withOpacity(0.1),
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

                        // Legal Registered Hospital Name
                        AppTextField(
                          label: 'Legal Registered Hospital Name',
                          hint: 'Enter legal hospital name',
                          controller: controller.legalNameController,
                          required: true,
                          validator: controller.validateHospitalName,
                        ),
                        const SizedBox(height: 16),

                        // State Selection
                        GetBuilder<HospitalRegistrationController>(
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
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                              hint: Text(
                                'Select State',
                                style: AppFonts.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              value: ctrl.stateController.text.isEmpty
                                  ? null
                                  : ctrl.stateController.text,
                              items: ctrl.statesList.map((String state) {
                                return DropdownMenuItem<String>(
                                  value: state,
                                  child: Text(
                                    state,
                                    style: AppFonts.labelMedium,
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  ctrl.stateController.text = newValue;
                                  ctrl.cityController.clear();
                                  ctrl.selectedCities.value =
                                      ctrl.getCitiesForState(newValue);
                                  ctrl.update();
                                }
                              },
                              validator: controller.validateState,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // City - Manual Input
                        AppTextField(
                          label: 'City',
                          hint: 'Enter your city',
                          controller: controller.cityController,
                          required: true,
                          validator: controller.validateCity,
                        ),
                        const SizedBox(height: 16),

                        // GSTIN Number
                        AppTextField(
                          label: 'GSTIN Number',
                          hint: 'Enter 15-character GSTIN',
                          controller: controller.gstinController,
                          required: true,
                          validator: controller.validateGSTIN,
                        ),
                        const SizedBox(height: 16),

                        // CE Registration Number
                        AppTextField(
                          label: 'Clinical Establishment (CE) Registration Number',
                          hint: 'Enter CE registration number',
                          controller: controller.ceRegistrationController,
                          required: true,
                          validator: controller.validateCENumber,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        AppTextField(
                          label: 'Email Address',
                          hint: 'Enter hospital email',
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

                        // Address
                        AppTextField(
                          label: 'Hospital Address',
                          hint: 'Enter complete address',
                          controller: controller.addressController,
                          maxLines: 3,
                        ),
                        const SizedBox(height: 32),

                        // Document Upload Section Header
                        Text(
                          'Required Documents *',
                          style: AppFonts.heading2.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Upload GST Certificate and CE License for verification',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // GST Certificate Upload
                        Obx(
                          () => DocumentUploadWidget(
                            documentName: 'GST Certificate',
                            fileName: controller.gstCertificateFileName.value,
                            onTap: controller.uploadGSTCertificate,
                            isRequired: true,
                            uploadedStatus:
                                controller.gstCertificateStatus.value.isEmpty
                                    ? null
                                    : controller.gstCertificateStatus.value,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // CE License Upload
                        Obx(
                          () => DocumentUploadWidget(
                            documentName: 'Clinical Establishment (CE) License',
                            fileName: controller.ceLicenseFileName.value,
                            onTap: controller.uploadCELicense,
                            isRequired: true,
                            uploadedStatus:
                                controller.ceLicenseStatus.value.isEmpty
                                    ? null
                                    : controller.ceLicenseStatus.value,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Information Box
                        Container(
                          padding: const EdgeInsets.all(AppConstants.paddingMedium),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withOpacity(0.1),
                            border: Border.all(
                              color: AppColors.primaryBlue.withOpacity(0.3),
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
                                '• Your registration will be marked as "Pending Verification" after submission.',
                              ),
                              _buildInfoPoint(
                                '• Admin will verify GSTIN and CE documents separately.',
                              ),
                              _buildInfoPoint(
                                '• Hospital can be marked active only after both verifications are completed.',
                              ),
                              _buildInfoPoint(
                                '• You will receive updates on verification status via email.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Submit Button
                        Obx(
                          () => AppButton(
                            text: 'Submit Registration',
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
                            onTap: () => Get.toNamed('/hospital/login'),
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
}
