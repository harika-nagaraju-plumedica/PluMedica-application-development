import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pharmacy/pharmacy_registration_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/document_upload_widget.dart';

/// Pharmacy registration form view
class PharmacyRegistrationView extends GetView<PharmacyRegistrationController> {
  const PharmacyRegistrationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Pharmacy Registration'),
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
                                'Pharmacy Registration',
                                style: AppFonts.heading2.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please provide your pharmacy details for verification',
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
                                child: Obx(
                                  () => Text(
                                    'Status: ${controller.registrationStatus.value}',
                                    style: AppFonts.bodySmall.copyWith(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ============ BASIC DETAILS SECTION ============
                        _buildSectionHeader('Basic Details'),
                        const SizedBox(height: 16),

                        // Legal Pharmacy Name
                        AppTextField(
                          label: 'Legal Pharmacy Name',
                          hint: 'Enter legal pharmacy name',
                          controller: controller.legalPharmacyNameController,
                          required: true,
                          validator: controller.validatePharmacyName,
                        ),
                        const SizedBox(height: 16),

                        // State Selection
                        _buildLabel('State', required: true),
                        const SizedBox(height: 8),
                        GetBuilder<PharmacyRegistrationController>(
                          builder: (ctrl) => DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingSmall,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.lightGrey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.lightGrey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium,
                                ),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryDarkBlue,
                                  width: 1.2,
                                ),
                              ),
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

                        // Pharmacy Phone Number
                        AppTextField(
                          label: 'Pharmacy Phone Number',
                          hint: 'Enter 10-digit mobile number',
                          controller: controller.pharmacyPhoneController,
                          keyboardType: TextInputType.phone,
                          required: true,
                          validator: controller.validatePharmacyPhone,
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
                        const SizedBox(height: 32),

                        // ============ LICENSE DETAILS SECTION ============
                        _buildSectionHeader('License Details'),
                        const SizedBox(height: 16),

                        // Drug License Checkbox
                        Obx(
                          () => CheckboxListTile(
                            title: Text(
                              'I have Drug License (Optional)',
                              style: AppFonts.labelMedium.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              'Tick if you have a valid Drug License',
                              style: AppFonts.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            value: controller.hasDrugLicense.value,
                            onChanged: (value) =>
                                controller.setHasDrugLicense(value ?? false),
                            controlAffinity:
                                ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // License Type Selection (visible when drug license is checked)
                        Obx(
                          () => controller.hasDrugLicense.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select License Type',
                                      style: AppFonts.labelMedium.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildLicenseTypeButton(
                                            'Retail',
                                            controller.licensType.value == 'Retail',
                                            () => controller
                                                .setLicenseType('Retail'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: _buildLicenseTypeButton(
                                            'Wholesale',
                                            controller.licensType.value ==
                                                'Wholesale',
                                            () => controller
                                                .setLicenseType('Wholesale'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    // License Form Selection
                                    if (controller.licensType.value != null)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Select License Form',
                                            style: AppFonts.labelMedium.copyWith(
                                              color: AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          GetBuilder<
                                              PharmacyRegistrationController>(
                                            builder: (ctrl) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: AppConstants
                                                    .paddingMedium,
                                                vertical: AppConstants
                                                    .paddingSmall,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.lightGrey,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  AppConstants
                                                      .borderRadiusMedium,
                                                ),
                                              ),
                                              child:
                                                  DropdownButtonFormField<
                                                      String>(
                                                isExpanded: true,
                                                decoration:
                                                    const InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                                hint: Text(
                                                  'Select form',
                                                  style: AppFonts.labelMedium
                                                      .copyWith(
                                                    color: AppColors
                                                        .textSecondary,
                                                  ),
                                                ),
                                                value: ctrl.selectedLicenseForm
                                                        .value,
                                                items: ctrl
                                                    .getAvailableLicenseForms()
                                                    .map((String form) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: form,
                                                    child: Text(
                                                      form,
                                                      style:
                                                          AppFonts.labelMedium,
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (String? newValue) {
                                                  if (newValue != null) {
                                                    ctrl.selectedLicenseForm
                                                        .value = newValue;
                                                    ctrl.update();
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    // Drug License Number
                                    AppTextField(
                                      label: 'Drug License Number',
                                      hint: 'Enter drug license number',
                                      controller:
                                          controller
                                              .drugLicenseNumberController,
                                      required: controller
                                          .hasDrugLicense.value,
                                      validator: controller.validateDrugLicense,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 32),

                        // ============ DOCUMENT UPLOAD SECTION ============
                        _buildSectionHeader('Document Uploads'),
                        const SizedBox(height: 8),
                        Text(
                          'Upload documents for verification (Optional: GST Certificate, Drug License)',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // GST Certificate Upload
                        Obx(
                          () => DocumentUploadWidget(
                            documentName: 'GST Certificate',
                            fileName:
                                controller.gstCertificateFileName.value,
                            onTap: controller.uploadGSTCertificate,
                            isRequired: false,
                            uploadedStatus: controller
                                    .gstCertificateStatus.value.isEmpty
                                ? null
                                : controller.gstCertificateStatus.value,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Drug License Certificate Upload (visible when drug license is checked)
                        Obx(
                          () => controller.hasDrugLicense.value
                              ? Column(
                                  children: [
                                    DocumentUploadWidget(
                                      documentName:
                                          'Drug License Certificate',
                                      fileName: controller
                                          .drugLicenseCertificateFileName
                                          .value,
                                      onTap: controller
                                          .uploadDrugLicenseCertificate,
                                      isRequired: controller
                                          .hasDrugLicense.value,
                                      uploadedStatus: controller
                                              .drugLicenseCertificateStatus
                                              .value
                                              .isEmpty
                                          ? null
                                          : controller
                                              .drugLicenseCertificateStatus
                                              .value,
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                        const SizedBox(height: 32),

                        // Registration Status Information
                        Container(
                          padding: const EdgeInsets.all(
                            AppConstants.paddingMedium,
                          ),
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
                                'Registration Status & Approval:',
                                style: AppFonts.heading3.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoPoint(
                                'G�� After submission, your pharmacy status will be "Pending Verification".',
                              ),
                              _buildInfoPoint(
                                'G�� Admin will review your GSTIN and documents.',
                              ),
                              _buildInfoPoint(
                                'G�� If Drug License is provided, it will also be verified.',
                              ),
                              _buildInfoPoint(
                                'G�� Your pharmacy will be marked as "Approved" only after admin verification.',
                              ),
                              _buildInfoPoint(
                                'G�� You will receive email notifications on status updates.',
                              ),
                              _buildInfoPoint(
                                'G�� In case of rejection, you can resubmit after addressing the issues.',
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
                            onTap: () => Get.toNamed('/pharmacy/login'),
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

  /// Build section header widget
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppFonts.heading2.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Build label with optional indicator
  Widget _buildLabel(String label, {bool required = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: RichText(
        text: TextSpan(
          text: label,
          style: AppFonts.labelMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          children: required
              ? [
                  TextSpan(
                    text: ' *',
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]
              : [],
        ),
      ),
    );
  }

  /// Build license type selection button
  Widget _buildLicenseTypeButton(
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? AppColors.primaryDarkBlue
                : AppColors.lightGrey,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadiusMedium,
          ),
          color: isSelected
              ? AppColors.primaryDarkBlue.withOpacity(0.1)
              : Colors.transparent,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppFonts.labelMedium.copyWith(
            color: isSelected
                ? AppColors.primaryDarkBlue
                : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Build info point widget
  Widget _buildInfoPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: AppFonts.bodySmall.copyWith(
          color: AppColors.textPrimary,
          height: 1.4,
        ),
      ),
    );
  }
}
