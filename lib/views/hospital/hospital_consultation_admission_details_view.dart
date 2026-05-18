import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/hospital/hospital_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/hospital/consultation_step_header_widget.dart';

class HospitalConsultationAdmissionDetailsView
    extends GetView<HospitalConsultationController> {
  const HospitalConsultationAdmissionDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Admission Details',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          children: [
            const ConsultationStepHeaderWidget(currentStep: 3),
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
                  _buildField(
                    'Date of Admission',
                    controller.dateOfAdmissionController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Date of Discharge',
                    controller.dateOfDischargeController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Consultations',
                    controller.consultationsController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField('Consultants', controller.consultantsController),
                  const SizedBox(height: AppConstants.paddingMedium),
                  _buildField(
                    'Admitted under',
                    controller.admittedUnderController,
                  ),
                  const SizedBox(height: AppConstants.paddingMedium),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: controller.openSearchScreen,
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: AppConstants.paddingSmall),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: controller.openFormScreen,
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
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
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
}
