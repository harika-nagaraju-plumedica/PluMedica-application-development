import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/hospital/hospital_payment_summary_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/hospital/payment_info_tile_widget.dart';

class HospitalPaymentSummaryView
    extends GetView<HospitalPaymentSummaryController> {
  const HospitalPaymentSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Payment Summary',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(
                          AppConstants.paddingMedium),
                      decoration: BoxDecoration(
                        gradient: AppColors.blueGradient,
                        borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Revenue',
                                style: AppFonts.bodyMedium
                                    .copyWith(
                                  color: AppColors.white
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'â‚¹${controller.totalRevenue.value.toStringAsFixed(0)}',
                                style: AppFonts.heading2
                                    .copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.attach_money,
                            color: AppColors.white,
                            size: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    Text(
                      'Pending Payments',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.pendingPayments.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingLarge),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Center(
                              child: Text(
                                'No pending payments',
                                style: AppFonts.bodyMedium
                                    .copyWith(
                                  color:
                                      AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.pendingPayments
                                .map(
                                  (payment) =>
                                      PaymentInfoTileWidget(
                                        description:
                                            'Patient Admission',
                                        amount: '5000',
                                        date: 'Jan 15, 2026',
                                        status: 'Pending',
                                        invoiceNumber:
                                            'INV-001',
                                      ),
                                )
                                .toList(),
                          ),
                    const SizedBox(
                        height: AppConstants.paddingLarge),
                    Text(
                      'Completed Payments',
                      style: AppFonts.heading3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingMedium),
                    controller.completedPayments.isEmpty
                        ? Container(
                            padding: const EdgeInsets.all(
                                AppConstants.paddingLarge),
                            decoration: BoxDecoration(
                              color: AppColors.veryLightGrey,
                              borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusLarge),
                            ),
                            child: Center(
                              child: Text(
                                'No completed payments',
                                style: AppFonts.bodyMedium
                                    .copyWith(
                                  color:
                                      AppColors.textSecondary,
                                ),
                              ),
                            ),
                          )
                        : Column(
                            children: controller.completedPayments
                                .map(
                                  (payment) =>
                                      PaymentInfoTileWidget(
                                        description:
                                            'Consultation Fee',
                                        amount: '500',
                                        date: 'Jan 10, 2026',
                                        status: 'Paid',
                                        invoiceNumber:
                                            'INV-002',
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

