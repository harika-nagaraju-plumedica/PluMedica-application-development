import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_payments_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Doctor Payments View
class DoctorPaymentsView extends GetView<DoctorPaymentsController> {
  const DoctorPaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Payments Received'),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshPayments,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Earnings Summary
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusMedium,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Earnings',
                              style: AppFonts.labelLarge.copyWith(
                                color: AppColors.white.withValues(alpha: 0.9),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Text(
                                'â‚¹${controller.totalEarnings.value.toStringAsFixed(2)}',
                                style: AppFonts.heading2.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Filter
                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: controller.paymentStatusOptions
                                .map(
                                  (status) => Obx(
                                    () => Padding(
                                      padding: const EdgeInsets.only(
                                        right: 8.0,
                                      ),
                                      child: InkWell(
                                        onTap: () => controller
                                            .applyPaymentFilter(status),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: controller
                                                        .filterPaymentStatus
                                                        .value ==
                                                    status
                                                ? AppColors.primaryBlue
                                                : AppColors.surface,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: controller
                                                          .filterPaymentStatus
                                                          .value ==
                                                      status
                                                  ? AppColors.primaryBlue
                                                  : AppColors.lightGrey,
                                            ),
                                          ),
                                          child: Text(
                                            status,
                                            style: AppFonts.labelLarge
                                                .copyWith(
                                              color: controller
                                                          .filterPaymentStatus
                                                          .value ==
                                                      status
                                                  ? AppColors.white
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Payments List
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.paddingMedium,
                        ),
                        child: Obx(
                          () => controller.filteredPayments.isEmpty
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(
                                    AppConstants.paddingLarge,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(
                                      AppConstants.borderRadiusMedium,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.payment,
                                        size: 48,
                                        color: AppColors.lightGrey,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No payments found',
                                        style: AppFonts.bodyMedium.copyWith(
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: controller.filteredPayments
                                      .map(
                                        (payment) =>
                                            GestureDetector(
                                          // TODO: Implement payment details view
                                          onTap: () {},
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            padding: const EdgeInsets.all(
                                              AppConstants.paddingMedium,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.lightGrey,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                AppConstants
                                                    .borderRadiusMedium,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Patient: ${payment.patientId}',
                                                            style: AppFonts
                                                                .labelLarge
                                                                .copyWith(
                                                              color: AppColors
                                                                  .textPrimary,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 4,
                                                          ),
                                                          Text(
                                                            payment
                                                                .paymentMethod,
                                                            style: AppFonts
                                                                .bodySmall
                                                                .copyWith(
                                                              color: AppColors
                                                                  .textSecondary,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Text(
                                                          'â‚¹${payment.amount.toStringAsFixed(2)}',
                                                          style: AppFonts
                                                              .labelLarge
                                                              .copyWith(
                                                            color: AppColors
                                                                .success,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 4,
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 8,
                                                            vertical: 4,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: payment
                                                                        .status ==
                                                                    'Paid'
                                                                ? AppColors
                                                                    .success
                                                                : AppColors
                                                                    .warning,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                              12,
                                                            ),
                                                          ),
                                                          child: Text(
                                                            payment.status,
                                                            style: AppFonts
                                                                .labelSmall
                                                                .copyWith(
                                                              color: AppColors
                                                                  .white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.calendar_today,
                                                      size: AppConstants
                                                          .iconSizeSmall,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Text(
                                                      payment.transactionDate
                                                          .toString()
                                                          .split(' ')[0],
                                                      style: AppFonts.bodySmall
                                                          .copyWith(
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                    if (payment
                                                            .transactionId !=
                                                        null)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 16),
                                                        child: Text(
                                                          'ID: ${payment.transactionId}',
                                                          style: AppFonts
                                                              .bodySmall
                                                              .copyWith(
                                                            color: AppColors
                                                                .textSecondary,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

