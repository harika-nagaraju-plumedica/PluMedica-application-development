import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_orders_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class PharmacyOrdersView extends GetView<PharmacyOrdersController> {
  const PharmacyOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: const Text('Orders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppConstants.paddingMedium,
              AppConstants.paddingMedium,
              AppConstants.paddingMedium,
              8,
            ),
            child: TextField(
              onChanged: controller.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search by Patient ID, Order ID, or medicine',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.borderRadiusMedium),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Row(
              children: [
                Obx(
                  () => Text(
                    'Orders (${controller.totalVisibleOrders})',
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Text(
                    '${controller.selectedTimeRange.value} - ${_formatDate(controller.selectedDate.value)}',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Daily', 'Weekly', 'Monthly', 'Yearly']
                    .map(
                      (range) => Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(range),
                            selected: controller.selectedTimeRange.value == range,
                            onSelected: (_) => controller.updateTimeRange(range),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingMedium,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () async {
                  final selected = await showDatePicker(
                    context: context,
                    initialDate: controller.selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (selected != null) {
                    controller.updateSelectedDate(selected);
                  }
                },
                icon: const Icon(Icons.calendar_month),
                label: const Text('Select Date'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: PharmacyOrdersController.orderFilters
                    .map(
                      (filter) => Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(
                              '$filter (${controller.getOrderCount(filter)})',
                            ),
                            selected: controller.selectedFilter.value == filter,
                            onSelected: (_) => controller.updateFilter(filter),
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.green.withOpacity(0.3),
                            labelStyle: AppFonts.bodySmall.copyWith(
                              color: controller.selectedFilter.value == filter
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
          ),
          Expanded(
            child: Obx(
              () => controller.filteredOrders.isEmpty
                  ? Center(
                      child: Text(
                        'No orders found',
                        style: AppFonts.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      itemCount: controller.filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = controller.filteredOrders[index];
                        return _buildOrderCard(order);
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final statusColor = _getStatusColor(order['status']);
    final medicines = (order['medicines'] as List).cast<Map<String, dynamic>>();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order['orderId'],
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                order['patientId'],
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  order['status'],
                  style: AppFonts.bodySmall.copyWith(
                    color: statusColor,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${order['customer']} (${order['customerType']})',
                      style: AppFonts.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['address'],
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order['phone'],
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${order['amount'].toStringAsFixed(2)}',
                    style: AppFonts.labelMedium.copyWith(
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order['items']} items',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: order['paymentStatus'] == 'Paid'
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      order['paymentStatus'],
                      style: AppFonts.bodySmall.copyWith(
                        color: order['paymentStatus'] == 'Paid'
                            ? AppColors.success
                            : AppColors.orange,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.veryLightGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Order Details',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...medicines.map(_buildMedicineStockTile),
              ],
            ),
          ),
          if (order['transactionId'] != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Transaction ID: ${order['transactionId']}',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (order['status'] == 'Prescription verification required')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescription verification required (non-Plumedica doctor).',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () {
                      final success =
                          controller.approvePrescription(order['orderId']);
                      if (success) {
                        Get.snackbar(
                          'Approved',
                          'Prescription verified by pharmacist.',
                          duration: const Duration(seconds: 1),
                        );
                      }
                    },
                    child: const Text('Approve Prescription'),
                  ),
                ],
              ),
            ),
          if (order['status'] == 'Processing' ||
              order['status'] == 'Pending' ||
              order['status'] == 'Prescription verification required')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    final completed = controller.completeOrder(order['orderId']);
                    if (completed) {
                      Get.snackbar(
                        'Order Updated',
                        '${order['orderId']} marked as Delivered.',
                        duration: const Duration(seconds: 1),
                      );
                    }
                  },
                  child: const Text('Mark Delivered'),
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            controller.formatOrderDate(order['dateTime'] as DateTime),
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicineStockTile(Map<String, dynamic> medicine) {
    final int remaining = medicine['remainingStock'] as int;
    final int total = medicine['totalStock'] as int;
    final int sold = total - remaining;
    final double ratio = total == 0 ? 0 : remaining / total;
    final Color statusColor = _stockStatusColor(ratio);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  medicine['name'].toString(),
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$remaining / $total ${medicine['unit']}',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                flex: remaining <= 0 ? 1 : remaining,
                child: Container(height: 8, color: statusColor),
              ),
              Expanded(
                flex: sold <= 0 ? 1 : sold,
                child: Container(
                  height: 8,
                  color: AppColors.lightGrey.withOpacity(0.6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Remaining: $remaining | Sold: $sold',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Color _stockStatusColor(double ratio) {
    if (ratio <= 0.3) return AppColors.warning;
    if (ratio < 0.8) return AppColors.primaryBlue;
    return AppColors.green;
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppColors.success;
      case 'pending':
        return AppColors.orange;
      case 'processing':
        return AppColors.primaryBlue;
      case 'prescription verification required':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
