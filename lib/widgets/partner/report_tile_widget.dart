import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class ReportTileWidgetItem extends StatelessWidget {
  final String title;
  final String date;
  final String type;
  final String? fileSize;
  final VoidCallback? onDownload;
  final VoidCallback? onShare;

  const ReportTileWidgetItem({
    Key? key,
    required this.title,
    required this.date,
    required this.type,
    this.fileSize,
    this.onDownload,
    this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      margin: const EdgeInsets.only(bottom: AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.veryLightGrey),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusMedium),
            ),
            child: const Icon(
              Icons.picture_as_pdf,
              color: AppColors.error,
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
                Row(
                  children: [
                    Text(
                      type,
                      style: AppFonts.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'â€¢ $date',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (fileSize != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        'â€¢ $fileSize',
                        style: AppFonts.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              if (onDownload != null)
                PopupMenuItem(
                  onTap: onDownload,
                  child: const Text('Download'),
                ),
              if (onShare != null)
                PopupMenuItem(
                  onTap: onShare,
                  child: const Text('Share'),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

