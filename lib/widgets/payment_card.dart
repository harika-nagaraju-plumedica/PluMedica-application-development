import 'package:flutter/material.dart';
import '../models/payment_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Payment Card Widget
class PaymentCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;
  final VoidCallback? onDownloadInvoice;

  const PaymentCard({
    Key? key,
    required this.payment,
    required this.onTap,
    this.onDownloadInvoice,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (payment.status) {
      case 'Paid':
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      case 'Failed':
        return AppColors.error;
      default:
        return AppColors.primaryBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.lightGrey),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
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
                        'Payment ID: ${payment.id}',
                        style: AppFonts.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Patient: ${payment.patientId}',
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
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    payment.status,
                    style: AppFonts.labelSmall.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${payment.amount.toStringAsFixed(2)}',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.primaryDarkBlue,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      payment.paymentMethod,
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      payment.transactionDate
                          .toString()
                          .split(' ')[0],
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (payment.transactionId != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'TXN: ${payment.transactionId}',
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            if (onDownloadInvoice != null && payment.invoiceUrl != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onDownloadInvoice,
                  icon: const Icon(Icons.download),
                  label: const Text('Download Invoice'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDarkBlue,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
