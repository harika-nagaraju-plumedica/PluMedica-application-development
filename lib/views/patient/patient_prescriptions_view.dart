import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient/patient_clinical_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class PatientPrescriptionsView extends GetView<PatientClinicalRecordsController> {
  const PatientPrescriptionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Prescription History'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: controller.prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = controller.prescriptions[index];
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
                    'Doctor: ${prescription.doctorName}',
                    style: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Date: ${prescription.createdAt.toString().split(' ').first}',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 10),
                  ...prescription.drugEntries.map(
                    (drug) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${drug.drugName} | ${drug.dosage} | ${drug.durationDays} days | ${drug.instructions}',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                  if (prescription.remarks.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Instructions: ${prescription.remarks}',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
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
