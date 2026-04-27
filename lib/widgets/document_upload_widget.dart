import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Document Upload Widget for uploading required documents
class DocumentUploadWidget extends StatelessWidget {
  final String documentName; // e.g., "GST Certificate", "CE License"
  final String? fileName;
  final VoidCallback onTap;
  final bool isRequired;
  final String? uploadedStatus; // "pending", "verified", "rejected"
  final String? rejectionReason;

  const DocumentUploadWidget({
    Key? key,
    required this.documentName,
    this.fileName,
    required this.onTap,
    this.isRequired = false,
    this.uploadedStatus,
    this.rejectionReason,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (uploadedStatus) {
      case 'verified':
        return AppColors.success;
      case 'rejected':
        return AppColors.error;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.primaryBlue;
    }
  }

  String _getStatusText() {
    switch (uploadedStatus) {
      case 'verified':
        return 'Verified âœ“';
      case 'rejected':
        return 'Rejected âœ—';
      case 'pending':
        return 'Pending Review...';
      default:
        return fileName ?? 'Tap to upload file';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        border: Border.all(
          color: _getStatusColor(),
          width: 2,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(
          AppConstants.borderRadiusMedium,
        ),
        color: _getStatusColor().withValues(alpha: 0.05),
      ),
      child: Column(
        children: [
          Icon(
            _getStatusIcon(),
            size: 48,
            color: _getStatusColor(),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                documentName,
                style: AppFonts.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (isRequired)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Text(
                    ' *',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _getStatusText(),
            style: AppFonts.labelMedium.copyWith(
              color: _getStatusColor(),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (uploadedStatus == 'rejected' && rejectionReason != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Reason: $rejectionReason',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          const SizedBox(height: 16),
          if (uploadedStatus != 'verified')
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusSmall,
                  ),
                ),
                child: Text(
                  fileName == null ? 'Browse Files' : 'Change File',
                  style: AppFonts.labelLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (uploadedStatus) {
      case 'verified':
        return Icons.check_circle_outline;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'pending':
        return Icons.schedule;
      default:
        return Icons.cloud_upload_outlined;
    }
  }
}

