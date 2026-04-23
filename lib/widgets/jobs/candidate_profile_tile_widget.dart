import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class CandidateProfileTileWidget extends StatelessWidget {
  final String candidateName;
  final String position;
  final String experience;
  final String? profileImage;
  final String applicationStatus;
  final VoidCallback onViewProfile;
  final VoidCallback? onReview;

  const CandidateProfileTileWidget({
    Key? key,
    required this.candidateName,
    required this.position,
    required this.experience,
    this.profileImage,
    required this.applicationStatus,
    required this.onViewProfile,
    this.onReview,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onViewProfile,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.lightGrey,
              backgroundImage: profileImage != null
                  ? AssetImage(profileImage!)
                  : null,
              child:
                  profileImage == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: AppConstants.paddingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    candidateName,
                    style: AppFonts.labelLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    position,
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    experience,
                    style: AppFonts.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    applicationStatus,
                    style: AppFonts.caption.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ),
                if (onReview != null) ...[
                  const SizedBox(height: 4),
                  TextButton(
                    onPressed: onReview,
                    child: const Text('Review'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
