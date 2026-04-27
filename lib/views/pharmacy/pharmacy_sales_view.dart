import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_sales_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class PharmacySalesView extends GetView<PharmacySalesController> {
  const PharmacySalesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: const Text('Sales & Revenue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Overview Cards
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildRevenueCard(
                  'Total Revenue',
                  'â‚¹${controller.totalRevenue.value.toStringAsFixed(2)}',
                  Icons.trending_up,
                  AppColors.green,
                ),
                _buildRevenueCard(
                  'Transactions',
                  '${controller.totalTransactions.value}',
                  Icons.shopping_cart,
                  AppColors.primaryBlue,
                ),
                _buildRevenueCard(
                  'Avg Order',
                  'â‚¹${controller.averageOrderValue.value.toStringAsFixed(2)}',
                  Icons.receipt,
                  AppColors.purple,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Time Range Filter
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Time Range',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                    .map(
                      (range) => Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(range),
                            selected: controller.selectedTimeRange.value == range,
                            onSelected: (_) =>
                                controller.updateTimeRange(range),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.green.withValues(alpha: 0.3),
                            labelStyle: AppFonts.bodySmall.copyWith(
                              color:
                                  controller.selectedTimeRange.value ==
                                      range
                                  ? AppColors.green
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Sales by Category
            Text(
              'Sales by Category',
              style: AppFonts.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: controller.salesByCategory
                    .map((category) => _buildCategoryRow(category))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods
            Text(
              'Payment Methods',
              style: AppFonts.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => Column(
                children: controller.paymentMethods
                    .map((method) => _buildPaymentMethodRow(method))
                    .toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Daily Sales Trend
            Text(
              'Daily Sales Trend',
              style: AppFonts.heading2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  children: controller.dailySalesData
                      .map((data) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      data['day'],
                                      style: AppFonts.bodySmall.copyWith(
                                        color: AppColors.textPrimary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'â‚¹${data['sales'].toStringAsFixed(2)}',
                                      style: AppFonts.bodySmall.copyWith(
                                        color: AppColors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (data['sales'] / 6000)
                                        .clamp(0.0, 1.0)
                                        .toDouble(),
                                    minHeight: 6,
                                    backgroundColor:
                                        AppColors.green.withValues(alpha: 0.1),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.green),
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppFonts.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(Map<String, dynamic> category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['category'],
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${category['transactions']} transactions',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                'â‚¹${category['revenue'].toStringAsFixed(2)}',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: category['percentage'] / 100,
              minHeight: 6,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${category['percentage']}% of total',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodRow(Map<String, dynamic> method) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['method'],
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${method['count']} transactions',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              Text(
                'â‚¹${method['amount'].toStringAsFixed(2)}',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: method['percentage'] / 100,
              minHeight: 6,
              backgroundColor: AppColors.purple.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.purple),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${method['percentage']}% of transactions',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

