import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class ApplicationStatusBadgeWidget extends StatelessWidget {
  final String status;

  const ApplicationStatusBadgeWidget({
    Key? key,
    required this.status,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'accepted':
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
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius:
            BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppFonts.caption.copyWith(
          color: _getStatusColor(),
          fontWeight: AppFonts.semiBold,
        ),
      ),
    );
  }
}
