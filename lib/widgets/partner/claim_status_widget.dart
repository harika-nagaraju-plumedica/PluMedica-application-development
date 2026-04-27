import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class ClaimStatusWidgetItem extends StatelessWidget {
  final String claimNumber;
  final String amount;
  final String date;
  final String status;
  final String description;
  final VoidCallback? onViewDetails;

  const ClaimStatusWidgetItem({
    Key? key,
    required this.claimNumber,
    required this.amount,
    required this.date,
    required this.status,
    required this.description,
    this.onViewDetails,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return AppColors.success;
      case 'pending':
        return AppColors.warning;
      case 'rejected':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

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
                      claimNumber,
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
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusSmall),
                ),
                child: Text(
                  status,
                  style: AppFonts.caption.copyWith(
                    color: _getStatusColor(),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Amount',
                    style: AppFonts.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    'â‚¹$amount',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              Text(
                date,
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (onViewDetails != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: onViewDetails,
              child: const Text('View Details'),
            ),
          ],
        ],
      ),
    );
  }
}

