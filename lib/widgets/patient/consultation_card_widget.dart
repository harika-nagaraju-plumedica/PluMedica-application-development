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
  final IconData iconData;
  final VoidCallback onVideoCall;
  final VoidCallback onChat;
  final VoidCallback onReschedule;

  const ConsultationCardWidget({
    Key? key,
    required this.doctorName,
    required this.specialization,
    this.profileImage,
    required this.dateTime,
    required this.status,
    this.iconData = Icons.video_call,
    required this.onVideoCall,
    required this.onChat,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUpcoming = status.toLowerCase() == 'upcoming';
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
          const SizedBox(height: AppConstants.paddingMedium),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isUpcoming ? onVideoCall : null,
                  icon: const Icon(Icons.video_call),
                  label: const Text('Video Call'),
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
