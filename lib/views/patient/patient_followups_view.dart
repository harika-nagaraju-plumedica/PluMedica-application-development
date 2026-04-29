import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient/patient_clinical_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class PatientFollowUpsView extends GetView<PatientClinicalRecordsController> {
  const PatientFollowUpsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Follow-up Timeline'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: controller.followUps.length,
          itemBuilder: (context, index) {
            final followUp = controller.followUps[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                border: Border.all(color: AppColors.lightGrey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${followUp.createdAt.toString().split(' ').first}',
                    style: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    followUp.notes,
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  if (followUp.updatedMedication != null)
                    Text(
                      'Medication update: ${followUp.updatedMedication}',
                      style: AppFonts.bodySmall.copyWith(color: AppColors.textPrimary),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    'Next visit: ${followUp.nextVisitDate.toString().split(' ').first}',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.primaryBlue),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
