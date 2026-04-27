import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Patient header widget with greeting and profile
class PatientHeaderWidget extends StatelessWidget {
  final String patientName;
  final String profileImage;
  final VoidCallback onProfileTap;

  const PatientHeaderWidget({
    Key? key,
    required this.patientName,
    required this.profileImage,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingMedium,
        vertical: AppConstants.paddingLarge,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.blueGradient,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patientName,
                  style: AppFonts.heading2.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.white,
              backgroundImage: AssetImage(profileImage),
            ),
          ),
        ],
      ),
    );
  }
}

