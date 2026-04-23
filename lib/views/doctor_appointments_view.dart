import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_appointments_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Doctor Appointments View
class DoctorAppointmentsView extends GetView<DoctorAppointmentsController> {
  const DoctorAppointmentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshAppointments,
                child: Column(
                  children: [
                    // Tab Navigation
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingSmall,
                      ),
                      color: AppColors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.switchTab('Pending'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller.selectedTab.value ==
                                              'Pending'
                                          ? AppColors.primaryBlue
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Pending',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.labelLarge.copyWith(
                                    color: controller.selectedTab.value ==
                                            'Pending'
                                        ? AppColors.primaryBlue
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.switchTab('Completed'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: controller.selectedTab.value ==
                                              'Completed'
                                          ? AppColors.primaryBlue
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  'Completed',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.labelLarge.copyWith(
                                    color: controller.selectedTab.value ==
                                            'Completed'
                                        ? AppColors.primaryBlue
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Appointments List
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(
                          AppConstants.paddingMedium,
                        ),
                        child: Obx(
                          () {
                            final appointments =
                                controller.selectedTab.value == 'Pending'
                                    ? controller.pendingAppointments
                                    : controller.completedAppointments;

                            return appointments.isEmpty
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
                                          Icons.calendar_today,
                                          size: 48,
                                          color: AppColors.lightGrey,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'No ${controller.selectedTab.value.toLowerCase()} appointments',
                                          style: AppFonts.bodyMedium.copyWith(
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Column(
                                    children: appointments
                                        .map(
                                          (appointment) => GestureDetector(
                                            // TODO: Implement appointment details view
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
                                                  color:
                                                      AppColors.lightGrey,
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
                                                              appointment
                                                                  .patientName,
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
                                                              appointment
                                                                  .reason ??
                                                                  'N/A',
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
                                                      Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                          horizontal: 12,
                                                          vertical: 6,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: appointment
                                                                      .mode ==
                                                                  'Virtual'
                                                              ? AppColors
                                                                  .purple
                                                              : AppColors.green,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            12,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          appointment.mode,
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
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons
                                                            .calendar_today,
                                                        size: AppConstants
                                                            .iconSizeSmall,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        appointment
                                                            .appointmentDate
                                                            .toString()
                                                            .split(' ')[0],
                                                        style: AppFonts
                                                            .bodySmall
                                                            .copyWith(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 16),
                                                      const Icon(
                                                        Icons.access_time,
                                                        size: AppConstants
                                                            .iconSizeSmall,
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        appointment.timeSlot,
                                                        style: AppFonts
                                                            .bodySmall
                                                            .copyWith(
                                                          color: AppColors
                                                              .textSecondary,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      if (appointment.status ==
                                                          'Pending')
                                                        ElevatedButton.icon(
                                                          onPressed: () =>
                                                              controller
                                                                  .markAsCompleted(
                                                            appointment,
                                                          ),
                                                          icon: const Icon(Icons
                                                              .check_circle),
                                                          label: const Text(
                                                            'Complete',
                                                          ),
                                                          style:
                                                              ElevatedButton
                                                                  .styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .success,
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
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
