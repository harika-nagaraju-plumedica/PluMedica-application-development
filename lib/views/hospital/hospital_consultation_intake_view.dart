import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hospital/hospital_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/hospital/consultation_step_header_widget.dart';

class HospitalConsultationIntakeView
    extends GetView<HospitalConsultationController> {
  const HospitalConsultationIntakeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Consultation Intake',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const ConsultationStepHeaderWidget(currentStep: 1),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _PromptTile(
                    label: 'Job Posting',
                    onTap: () =>
                        controller.navigateToModule('/hospital/job_postings'),
                  ),
                  SizedBox(height: AppConstants.paddingSmall),
                  _PromptTile(
                    label: 'Schedule consultation timing ?',
                    onTap: controller.openSearchScreen,
                  ),
                  SizedBox(height: AppConstants.paddingSmall),
                  _PromptTile(
                    label: 'Patient Admission ?',
                    onTap: controller.openAdmissionDetailsScreen,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: _cardDecoration(),
              child: Column(
                children: [
                  _buildField(
                    label: 'Patient Admission under Dr ?',
                    controller: controller.patientAdmissionUnderDrController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    label: 'Admission department',
                    controller: controller.admissionDepartmentController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    label: 'Payment',
                    controller: controller.paymentController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Emergency admission / yes no',
                          style: AppFonts.labelMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isEmergencyAdmission.value,
                          onChanged: (value) {
                            controller.isEmergencyAdmission.value = value;
                          },
                          activeThumbColor: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.openConsultationHub,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: AppConstants.paddingSmall),
                Expanded(
                  child: ElevatedButton(
                    onPressed: controller.openSearchScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarkBlue,
                      foregroundColor: AppColors.white,
                    ),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
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

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      border: Border.all(color: AppColors.veryLightGrey),
    );
  }
}

class _PromptTile extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _PromptTile({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMedium,
          vertical: AppConstants.paddingSmall,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: AppFonts.bodyMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}
