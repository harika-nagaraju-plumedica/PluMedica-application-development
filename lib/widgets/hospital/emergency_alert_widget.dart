import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Emergency alert widget for hospital
class EmergencyAlertWidgetItem extends StatelessWidget {
  final String patientName;
  final String bedNumber;
  final String description;
  final String severity;
  final DateTime? alertTime;
  final VoidCallback onAcknowledge;
  final VoidCallback? onRespond;

  const EmergencyAlertWidgetItem({
    Key? key,
    required this.patientName,
    required this.bedNumber,
    required this.description,
    required this.severity,
    this.alertTime,
    required this.onAcknowledge,
    this.onRespond,
  }) : super(key: key);

  Color _getSeverityColor() {
    switch (severity.toLowerCase()) {
      case 'critical':
        return AppColors.error;
      case 'high':
        return AppColors.warning;
      case 'medium':
        return AppColors.primaryBlue;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor();
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: severityColor.withValues(alpha: 0.05),
        border: Border.all(color: severityColor),
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
                    Row(
                      children: [
                        Icon(Icons.error, color: severityColor, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            patientName,
                            style: AppFonts.labelLarge.copyWith(
                              color: severityColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Bed: $bedNumber',
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
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
                  color: severityColor.withValues(alpha: 0.2),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Text(
                  severity.toUpperCase(),
                  style: AppFonts.caption.copyWith(
                    color: severityColor,
                    fontWeight: AppFonts.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          if (alertTime != null) ...[
            const SizedBox(height: 8),
            Text(
              'Alert Time: ${alertTime!.hour}:${alertTime!.minute}',
              style: AppFonts.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onAcknowledge,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: severityColor,
                  ),
                  child: const Text('Acknowledge'),
                ),
              ),
              if (onRespond != null) ...[
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRespond,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: severityColor,
                    ),
                    child: const Text('Respond'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

