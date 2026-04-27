import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class PartnerInfoCardWidget extends StatelessWidget {
  final String partnerName;
  final String partnerType;
  final String memberCount;
  final String? logoImage;
  final VoidCallback? onTap;

  const PartnerInfoCardWidget({
    super.key,
    required this.partnerName,
    required this.partnerType,
    required this.memberCount,
    this.logoImage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.veryLightGrey),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.lightGrey,
              backgroundImage:
                  logoImage != null ? AssetImage(logoImage!) : null,
              child: logoImage == null
                  ? const Icon(Icons.business)
                  : null,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    partnerName,
                    style: AppFonts.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    partnerType,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Members: $memberCount',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
