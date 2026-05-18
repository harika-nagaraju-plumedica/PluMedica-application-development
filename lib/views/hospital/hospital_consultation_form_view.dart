import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hospital/hospital_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/hospital/consultation_step_header_widget.dart';

class HospitalConsultationFormView
    extends GetView<HospitalConsultationController> {
  const HospitalConsultationFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Consultation Form',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const ConsultationStepHeaderWidget(currentStep: 4),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusLarge,
                ),
                border: Border.all(color: AppColors.veryLightGrey),
              ),
              child: Column(
                children: [
                  _buildField('Urgent Guid', controller.urgentGuideController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Specialisation',
                    controller.specialisationController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Reason for consultation',
                    controller.reasonForConsultationController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Description',
                    controller.descriptionController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.saveConsultationDraft,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDarkBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Save Consultation Draft'),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.submitConsultation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Submit Consultation'),
                    ),
                  ),
                  const SizedBox(height: AppConstants.paddingSmall),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: controller.openAdmissionDetailsScreen,
                      child: const Text('Back'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppFonts.labelMedium.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.borderRadiusMedium,
              ),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
          ),
        ),
      ],
    );
  }
}
