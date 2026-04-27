import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Widget to display admission status
class AdmissionStatusWidgetItem extends StatelessWidget {
  final String patientName;
  final String wardNumber;
  final String bedNumber;
  final String admissionDate;
  final String status;
  final String? diagnosisCode;
  final VoidCallback? onTap;

  const AdmissionStatusWidgetItem({
    Key? key,
    required this.patientName,
    required this.wardNumber,
    required this.bedNumber,
    required this.admissionDate,
    required this.status,
    this.diagnosisCode,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'critical':
        return AppColors.error;
      case 'stable':
        return AppColors.success;
      case 'recovering':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.veryLightGrey),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          text: 'Ward: $wardNumber | ',
                          style: AppFonts.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          children: [
                            TextSpan(text: 'Bed: $bedNumber'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    status,
                    style: AppFonts.caption.copyWith(
                      color: _getStatusColor(),
                      fontWeight: AppFonts.semiBold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppColors.textSecondary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Admitted: $admissionDate',
                  style: AppFonts.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

