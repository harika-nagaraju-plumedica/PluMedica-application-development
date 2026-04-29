import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_appointments_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Doctor Appointments View
class DoctorAppointmentsView extends GetView<DoctorAppointmentsController> {
  const DoctorAppointmentsView({super.key});

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
                    // Filters Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      color: AppColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filters',
                            style: AppFonts.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            onChanged: controller.updatePatientIdQuery,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: 'Search Patient ID',
                              filled: true,
                              fillColor: AppColors.surface,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    controller.selectedDate.value ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                controller.selectDate(pickedDate);
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingSmall,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_month,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.selectedDate.value == null
                                          ? 'Select appointment date'
                                          : '${controller.selectedDate.value!.day.toString().padLeft(2, '0')}/${controller.selectedDate.value!.month.toString().padLeft(2, '0')}/${controller.selectedDate.value!.year}',
                                      style: AppFonts.labelMedium.copyWith(
                                        color: controller.selectedDate.value == null
                                            ? AppColors.textSecondary
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  if (controller.selectedDate.value != null)
                                    GestureDetector(
                                      onTap: controller.clearDateFilter,
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 8),
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tab Navigation
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingSmall,
                      ),
                      color: AppColors.surface,
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.switchTab('Waiting'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.selectedTab.value == 'Waiting'
                                      ? AppColors.primaryBlue
                                      : AppColors.white,
                                  border: Border.all(
                                      color: controller.selectedTab.value ==
                                              'Waiting'
                                          ? AppColors.primaryBlue
                                          : AppColors.lightGrey,
                                    ),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusSmall,
                                  ),
                                  boxShadow: [
                                    if (controller.selectedTab.value == 'Waiting')
                                      BoxShadow(
                                        color: AppColors.primaryBlue.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  'Waiting',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.labelLarge.copyWith(
                                    color: controller.selectedTab.value ==
                                            'Waiting'
                                        ? AppColors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => controller.switchTab('Completed'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppConstants.paddingMedium,
                                ),
                                decoration: BoxDecoration(
                                  color: controller.selectedTab.value == 'Completed'
                                      ? AppColors.primaryBlue
                                      : AppColors.white,
                                  border: Border.all(
                                    color: controller.selectedTab.value ==
                                            'Completed'
                                        ? AppColors.primaryBlue
                                        : AppColors.lightGrey,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusSmall,
                                  ),
                                  boxShadow: [
                                    if (controller.selectedTab.value == 'Completed')
                                      BoxShadow(
                                        color: AppColors.primaryBlue.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                  ],
                                ),
                                child: Text(
                                  'Completed',
                                  textAlign: TextAlign.center,
                                  style: AppFonts.labelLarge.copyWith(
                                    color: controller.selectedTab.value ==
                                            'Completed'
                                        ? AppColors.white
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
                                controller.selectedTab.value == 'Waiting'
                                    ? controller.waitingAppointments
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
                                                  SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      children: [
                                                        if (appointment.mode ==
                                                                'Virtual' &&
                                                            controller.selectedTab
                                                                    .value ==
                                                                'Waiting') ...[
                                                          ElevatedButton.icon(
                                                            onPressed: () =>
                                                                controller
                                                                    .openVirtualConsultation(
                                                              appointment,
                                                            ),
                                                            icon: const Icon(
                                                              Icons.videocam,
                                                            ),
                                                            label: const Text(
                                                              'Virtual',
                                                            ),
                                                            style:
                                                                ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  AppColors
                                                                      .primaryBlue,
                                                              foregroundColor:
                                                                  AppColors
                                                                      .white,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 8,
                                                          ),
                                                        ],
                                                        if (controller
                                                                .selectedTab
                                                                .value ==
                                                            'Waiting')
                                                          Wrap(
                                                            spacing: 8,
                                                            children: [
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    controller
                                                                        .acceptAppointment(
                                                                  appointment,
                                                                ),
                                                                style:
                                                                    OutlinedButton.styleFrom(
                                                                  foregroundColor:
                                                                      AppColors
                                                                          .success,
                                                                  side: const BorderSide(
                                                                    color:
                                                                        AppColors
                                                                            .success,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'Accept',
                                                                ),
                                                              ),
                                                              OutlinedButton(
                                                                onPressed: () =>
                                                                    controller
                                                                        .rejectAppointment(
                                                                  appointment,
                                                                ),
                                                                style:
                                                                    OutlinedButton.styleFrom(
                                                                  foregroundColor:
                                                                      AppColors
                                                                          .error,
                                                                  side: const BorderSide(
                                                                    color:
                                                                        AppColors
                                                                            .error,
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Text(
                                                                  'Reject',
                                                                ),
                                                              ),
                                                              Builder(
                                                                builder: (context) {
                                                                  final postponeOptions =
                                                                      controller.getRequestedPostponeSlots(
                                                                    appointment,
                                                                  );
                                                                  return PopupMenuButton<String>(
                                                                    onSelected: (slot) =>
                                                                        controller.postponeAppointment(
                                                                      appointment: appointment,
                                                                      newTimeSlot: slot,
                                                                    ),
                                                                    enabled: postponeOptions.isNotEmpty,
                                                                    itemBuilder: (context) =>
                                                                        postponeOptions
                                                                            .map(
                                                                              (slot) => PopupMenuItem<String>(
                                                                                value: slot,
                                                                                child: Text(slot),
                                                                              ),
                                                                            )
                                                                            .toList(),
                                                                    child: Container(
                                                                      padding: const EdgeInsets.symmetric(
                                                                        horizontal: 12,
                                                                        vertical: 10,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                          color: postponeOptions.isEmpty
                                                                              ? AppColors.lightGrey
                                                                              : AppColors.warning,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                      child: Row(
                                                                        mainAxisSize: MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            postponeOptions.isEmpty
                                                                                ? 'Await Patient Slot'
                                                                                : 'Postpone',
                                                                            style: AppFonts.bodySmall.copyWith(
                                                                              color: postponeOptions.isEmpty
                                                                                  ? AppColors.textSecondary
                                                                                  : AppColors.warning,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 4),
                                                                          Icon(
                                                                            Icons.arrow_drop_down,
                                                                            size: 18,
                                                                            color: postponeOptions.isEmpty
                                                                                ? AppColors.textSecondary
                                                                                : AppColors.warning,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
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
