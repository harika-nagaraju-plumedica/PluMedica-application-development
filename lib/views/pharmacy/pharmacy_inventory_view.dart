import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_inventory_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class PharmacyInventoryView extends GetView<PharmacyInventoryController> {
  const PharmacyInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: const Text('Inventory'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: PharmacyInventoryController.allowedCategories
                    .map(
                      (category) => Obx(
                        () => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: controller.selectedCategory.value == category,
                            onSelected: (isSelected) {
                              if (!isSelected) return;
                              controller.updateCategory(category);
                            },
                            backgroundColor: Colors.white,
                            selectedColor: AppColors.green.withValues(alpha: 0.3),
                            labelStyle: AppFonts.bodySmall.copyWith(
                              color: controller.selectedCategory.value == category
                                  ? AppColors.green
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              final filteredItems = controller.filteredInventory;
              if (filteredItems.isEmpty) {
                return Center(
                  child: Text(
                    'No items found',
                    style: AppFonts.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  return _buildInventoryCard(item);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryCard(Map<String, dynamic> item) {
    final remainingStock = _asInt(item['remainingStock'] ?? item['stock']);
    final meanLimit = _asInt(item['meanLimit'] ?? item['minStock']);
    final maxLimit = _asInt(item['maxLimit'] ?? item['maxStock']);
    final fallbackTotal = maxLimit > 0 ? maxLimit : 1;
    final totalStock = _asInt(item['totalStock'] ?? fallbackTotal).clamp(1, 1 << 30);
    final safeRemaining = remainingStock.clamp(0, totalStock);
    final soldStock = (totalStock - safeRemaining).clamp(0, totalStock);
    final status = controller.stockStatus(item);
    final statusColor = controller.getStockStatusColor(item);
    final isLowStock = status == 'Low';
    final stockPercentage = safeRemaining / totalStock;
    final price = _asDouble(item['price']);
    final timelineEvents = controller.timelineForItem(item);

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
        border: Border.all(
          color: isLowStock
              ? AppColors.stockLow.withValues(alpha: 0.3)
              : Colors.transparent,
          width: isLowStock ? 1 : 0,
        ),
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
                      item['name']?.toString() ?? 'Unknown medicine',
                      style: AppFonts.labelMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['manufacturer']?.toString() ?? 'Unknown manufacturer',
                      style: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.stockLow.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    'Low Stock',
                    style: AppFonts.bodySmall.copyWith(
                      color: AppColors.stockLow,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stockPercentage,
              minHeight: 8,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$status Stock',
              style: AppFonts.bodySmall.copyWith(
                color: statusColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$safeRemaining / $totalStock ${item['unit'] ?? 'units'}',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rs ${price.toStringAsFixed(2)}',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Remaining: $safeRemaining | Sold: $soldStock',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Mean limit: $meanLimit | Max limit: $maxLimit',
            style: AppFonts.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expires: ${item['expiryDate']?.toString() ?? '-'}',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                item['itemId']?.toString() ?? '-',
                style: AppFonts.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Stock Timeline',
                style: AppFonts.labelMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showAddInStockDialog(item),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add In-stock'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.green,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (timelineEvents.isEmpty)
            Text(
              'No stock movement recorded',
              style: AppFonts.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            )
          else
            Column(
              children: timelineEvents
                  .take(6)
                  .map((event) => _buildTimelineEventRow(event))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineEventRow(Map<String, dynamic> event) {
    final type = event['type']?.toString() ?? 'Stock update';
    final quantity = _asInt(event['quantity']);
    final dateTime = event['dateTime'] is DateTime
        ? event['dateTime'] as DateTime
        : DateTime.tryParse(event['dateTime']?.toString() ?? '') ??
              DateTime(1970, 1, 1);

    final isInStock = type.toLowerCase().contains('in-stock');
    final isSold = type.toLowerCase().contains('sold');
    final isOutStock = type.toLowerCase().contains('out-of-stock');

    final Color color = isInStock
        ? AppColors.green
        : isSold
        ? AppColors.primaryBlue
        : isOutStock
        ? AppColors.stockLow
        : AppColors.textSecondary;

    final IconData icon = isInStock
        ? Icons.south_west
        : isSold
        ? Icons.north_east
        : isOutStock
        ? Icons.warning_amber_rounded
        : Icons.sync_alt;

    final quantityLabel = quantity > 0 ? '$quantity units' : '-';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: AppFonts.bodySmall.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$quantityLabel | ${controller.formatDateTime(dateTime)}',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddInStockDialog(Map<String, dynamic> item) {
    final quantityController = TextEditingController();
    DateTime selectedDateTime = DateTime.now();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(
              'Add In-stock',
              style: AppFonts.labelLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name']?.toString() ?? '-',
                  style: AppFonts.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity received',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDateTime,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2035),
                    );
                    if (pickedDate == null) {
                      return;
                    }

                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
                    );
                    if (pickedTime == null) {
                      return;
                    }

                    setState(() {
                      selectedDateTime = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  },
                  icon: const Icon(Icons.calendar_month, size: 16),
                  label: Text(controller.formatDateTime(selectedDateTime)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: Get.back,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final quantity = int.tryParse(quantityController.text.trim());
                  if (quantity == null || quantity <= 0) {
                    Get.snackbar(
                      'Invalid Quantity',
                      'Enter a valid quantity greater than 0',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }

                  controller.addInStockEntry(
                    itemId: item['itemId']?.toString() ?? '',
                    quantity: quantity,
                    receivedAt: selectedDateTime,
                  );
                  Get.back();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      ),
    );
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  double _asDouble(dynamic value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
