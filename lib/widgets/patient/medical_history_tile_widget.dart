import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Tile widget for displaying medical history entries
class MedicalHistoryTileWidget extends StatelessWidget {
  final String title;
  final String description;
  final String date;
  final String? doctorName;
  final IconData icon;
  final VoidCallback? onTap;

  const MedicalHistoryTileWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.date,
    this.doctorName,
    required this.icon,
    this.onTap,
  }) : super(key: key);

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlue.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadiusMedium),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.lightBlue,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingMedium),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date,
                  style: AppFonts.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (doctorName != null)
                  Text(
                    'Dr. $doctorName',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.primaryBlue,
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
