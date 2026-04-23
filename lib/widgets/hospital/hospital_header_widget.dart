import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Hospital header widget with hospital info
class HospitalHeaderWidget extends StatelessWidget {
  final String hospitalName;
  final String hospitalLogo;
  final VoidCallback onSettingsTap;

  const HospitalHeaderWidget({
    Key? key,
    required this.hospitalName,
    required this.hospitalLogo,
    required this.onSettingsTap,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.white,
              backgroundImage: AssetImage(hospitalLogo),
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: AppFonts.bodyMedium.copyWith(
                    color: AppColors.white.withOpacity(0.8),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  hospitalName,
                  style: AppFonts.heading2.copyWith(
                    color: AppColors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              icon: const Icon(Icons.settings, color: AppColors.white),
              onPressed: onSettingsTap,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
