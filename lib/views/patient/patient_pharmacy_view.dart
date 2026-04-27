import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_pharmacy_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/pharmacy_item_widget.dart';
import '../../widgets/app_text_field.dart';

class PatientPharmacyView extends GetView<PatientPharmacyController> {
  const PatientPharmacyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Pharmacy',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: controller.proceedToCheckout,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Obx(
                  () => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${controller.cart.length}',
                      style: AppFonts.caption.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      label: 'Search Medicines',
                      hint: 'Search by name or doctors prescription',
                      prefixIcon: Icons.search,
                      onChanged: controller.search,
                    ),
                    const SizedBox(height: AppConstants.paddingLarge),
                    Text(
                      'Available Medicines',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.medicines.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.medication,
                                  size: 64,
                                  color: AppColors.lightGrey,
                                ),
                                const SizedBox(
                                    height: AppConstants.paddingMedium),
                                Text(
                                  'No medicines available',
                                  style: AppFonts.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Column(
                            children: controller.medicines
                                .map(
                                  (medicine) =>
                                      PharmacyItemWidget(
                                        medicineName: 'Aspirin',
                                        dosage: '500mg - 10 tablets',
                                        price: '150',
                                        onOrderPressed:
                                            () =>
                                                controller.addToCart(
                                                    medicine),
                                      ),
                                )
                                .toList(),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
