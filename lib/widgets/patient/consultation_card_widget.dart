import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Widget for displaying doctor consultation appointment card
class ConsultationCardWidget extends StatelessWidget {
  final String doctorName;
  final String specialization;
  final String? profileImage;
  final String dateTime;
  final String status;
  final String mode;
  final bool isHomeTreatment;
  final String problemSummary;
  final String paymentStatus;
  final String amountText;
  final IconData iconData;
  final VoidCallback onVideoCall;
  final VoidCallback onChat;
  final VoidCallback onReschedule;
  final VoidCallback? onPayNow;

  const ConsultationCardWidget({
    Key? key,
    required this.doctorName,
    required this.specialization,
    this.profileImage,
    required this.dateTime,
    required this.status,
    required this.mode,
    required this.isHomeTreatment,
    required this.problemSummary,
    required this.paymentStatus,
    required this.amountText,
    this.iconData = Icons.video_call,
    required this.onVideoCall,
    required this.onChat,
    required this.onReschedule,
    this.onPayNow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUpcoming = status.toLowerCase() == 'upcoming';
    final isPendingPayment =
      paymentStatus.toLowerCase() == 'pending' && onPayNow != null;
    final statusColor =
        isUpcoming ? AppColors.warning : AppColors.success;

    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.veryLightGrey),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: profileImage != null
                    ? AssetImage(profileImage!)
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: AppConstants.paddingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorName,
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      specialization,
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Text(
                  status,
                  style: AppFonts.caption.copyWith(
                    color: statusColor,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: AppColors.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                dateTime,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                isHomeTreatment ? Icons.home : Icons.video_call,
                color: AppColors.primaryBlue,
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  mode,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: AppFonts.medium,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: paymentStatus.toLowerCase() == 'paid'
                      ? AppColors.success.withOpacity(0.12)
                      : AppColors.warning.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                ),
                child: Text(
                  '$paymentStatus | $amountText',
                  style: AppFonts.caption.copyWith(
                    color: paymentStatus.toLowerCase() == 'paid'
                        ? AppColors.success
                        : AppColors.warning,
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Problem: $problemSummary',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      isUpcoming && !isHomeTreatment ? onVideoCall : null,
                  icon: const Icon(Icons.video_call),
                  label: Text(isHomeTreatment ? 'Home Visit' : 'Video Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    disabledBackgroundColor: AppColors.lightGrey,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onChat,
                  icon: const Icon(Icons.chat),
                  label: const Text('Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          if (isPendingPayment)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onPayNow,
                  icon: const Icon(Icons.payment),
                  label: const Text('Pay Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 8),
          if (isUpcoming)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onReschedule,
                child: Text(
                  'Reschedule',
                  style: AppFonts.labelMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
