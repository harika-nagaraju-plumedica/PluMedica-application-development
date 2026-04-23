import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

/// Widget for displaying pharmacy medicine item
class PharmacyItemWidget extends StatelessWidget {
  final String medicineName;
  final String dosage;
  final String price;
  final String? imageUrl;
  final bool inStock;
  final VoidCallback onOrderPressed;

  const PharmacyItemWidget({
    Key? key,
    required this.medicineName,
    required this.dosage,
    required this.price,
    this.imageUrl,
    this.inStock = true,
    required this.onOrderPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(
          color: inStock ? AppColors.veryLightGrey : AppColors.lightGrey,
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius:
                  BorderRadius.circular(AppConstants.borderRadiusMedium),
              image: imageUrl != null
                  ? DecorationImage(
                      image: AssetImage(imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageUrl == null
                ? const Icon(Icons.medication, color: AppColors.lightGrey)
                : null,
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicineName,
                  style: AppFonts.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  dosage,
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹$price',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.green,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: inStock
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusSmall),
                      ),
                      child: Text(
                        inStock ? 'In Stock' : 'Out of Stock',
                        style: AppFonts.caption.copyWith(
                          color: inStock
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: AppFonts.semiBold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppConstants.paddingMedium),
          SizedBox(
            width: 40,
            child: ElevatedButton(
              onPressed: inStock ? onOrderPressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                disabledBackgroundColor: AppColors.lightGrey,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
              ),
              child: const Icon(Icons.add, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
