import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/patient/patient_clinical_records_controller.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class PatientReferralsView extends GetView<PatientClinicalRecordsController> {
  const PatientReferralsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Referral Inbox'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: controller.referrals.length,
          itemBuilder: (context, index) {
            final referral = controller.referrals[index];
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
                    'Referral ID: ${referral.id}',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.primaryBlue),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Patient: ${referral.patientName} (${referral.patientId})',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'From: ${referral.referringDoctorName} (${referral.referringDoctorId})',
                    style: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'To: ${referral.referredDoctorName} (${referral.referredDoctorId})',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Reason: ${referral.reason}',
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    referral.description,
                    style: AppFonts.bodySmall.copyWith(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: referral.status == 'Pending'
                              ? () => controller.ignoreReferral(referral.id)
                              : null,
                          child: const Text('Ignore'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: referral.status == 'Pending'
                              ? () => controller.acceptReferral(referral.id)
                              : null,
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status: ${referral.status}',
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
