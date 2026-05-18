import 'package:flutter/material.dart';

import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';

class ConsultationStepHeaderWidget extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> stepLabels;

  const ConsultationStepHeaderWidget({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
    this.stepLabels = const ['Intake', 'Search', 'Admission', 'Form'],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        border: Border.all(color: AppColors.veryLightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Step $currentStep/$totalSteps',
            style: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Row(
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isActive = stepNumber == currentStep;
              final isComplete = stepNumber < currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: isComplete || isActive
                              ? AppColors.primaryBlue
                              : AppColors.veryLightGrey,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    if (stepNumber != totalSteps)
                      const SizedBox(width: AppConstants.paddingSmall),
                  ],
                ),
              );
            }),
          ),
          const SizedBox(height: AppConstants.paddingSmall),
          Wrap(
            spacing: AppConstants.paddingSmall,
            runSpacing: 4,
            children: List.generate(totalSteps, (index) {
              final stepNumber = index + 1;
              final isActive = stepNumber == currentStep;
              return Text(
                '$stepNumber. ${stepLabels[index]}',
                style: AppFonts.bodySmall.copyWith(
                  color: isActive
                      ? AppColors.primaryDarkBlue
                      : AppColors.textSecondary,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
