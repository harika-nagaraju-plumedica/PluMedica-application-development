import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class JobCardWidgetItem extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String location;
  final String salary;
  final String jobType;
  final List<String> tags;
  final VoidCallback onTap;

  const JobCardWidgetItem({
    Key? key,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.salary,
    required this.jobType,
    required this.tags,
    required this.onTap,
  }) : super(key: key);

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
                        jobTitle,
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        companyName,
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
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusSmall),
                  ),
                  child: Text(
                    jobType,
                    style: AppFonts.caption.copyWith(
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on,
                    color: AppColors.textSecondary, size: 14),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                Text(
                  salary,
                  style: AppFonts.labelMedium.copyWith(
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              children: tags
                  .take(3)
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      labelStyle: AppFonts.caption.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                      backgroundColor:
                          AppColors.lightBlue.withValues(alpha: 0.1),
                      side: BorderSide.none,
                      padding: EdgeInsets.zero,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

