import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Widget for displaying fitness statistics (BMI, Steps, etc.)
class FitnessStatWidget extends StatelessWidget {
  final String label;
  final String value;
  final String? additionalInfo;
  final Color statusColor;
  final IconData icon;
  final LinearGradient? gradient;

  const FitnessStatWidget({
    Key? key,
    required this.label,
    required this.value,
    this.additionalInfo,
    this.statusColor = AppColors.green,
    required this.icon,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? AppColors.white : null,
        border: gradient == null ? Border.all(color: AppColors.veryLightGrey) : null,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: statusColor, size: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Text(
                  'Good',
                  style: AppFonts.caption.copyWith(
                    color: statusColor,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.heading2.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (additionalInfo != null) ...[
            const SizedBox(height: 4),
            Text(
              additionalInfo!,
              style: AppFonts.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

