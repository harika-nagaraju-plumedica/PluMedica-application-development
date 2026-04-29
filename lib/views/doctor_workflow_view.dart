import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

class DoctorWorkflowView extends StatelessWidget {
  const DoctorWorkflowView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Doctor Workflow'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What To Do (Doctor Module)',
              style: AppFonts.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Follow this order for every patient case in the old doctor module.',
              style: AppFonts.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            _stepCard(
              step: 'Step 1',
              title: 'Open Patient Context',
              description:
                  'Go to Patient History, select the patient card and review diagnosis/history.',
              buttonText: 'Go To Patient History',
              onPressed: () => Get.toNamed('/doctor_patient_history'),
            ),
            _stepCard(
              step: 'Step 2',
              title: 'Create Prescription',
              description:
                  'Create prescription with multiple drugs, timing, and remarks.',
              buttonText: 'Go To Prescriptions',
              onPressed: () => Get.toNamed('/doctor_prescriptions'),
            ),
            _stepCard(
              step: 'Step 3',
              title: 'Add Follow-up',
              description:
                  'In Prescription History, open a prescription and tap Add Follow-up.',
              buttonText: 'Open Prescription History',
              onPressed: () => Get.toNamed('/doctor_prescriptions'),
            ),
            _stepCard(
              step: 'Step 4',
              title: 'Refer Doctor (If Needed)',
              description:
                  'Use Refer Doctor from Patient Details or Prescription screen.',
              buttonText: 'Open Refer Flow',
              onPressed: () => Get.toNamed('/doctor_patient_history'),
            ),
            _stepCard(
              step: 'Step 5',
              title: 'Manage Availability',
              description:
                  'Update area, specialization mapping and weekly slots in Doctor Registration screen.',
              buttonText: 'Open Doctor Registration',
              onPressed: () => Get.toNamed('/doctor_registration'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepCard({
    required String step,
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
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
            '$step: $title',
            style: AppFonts.labelLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: onPressed,
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
