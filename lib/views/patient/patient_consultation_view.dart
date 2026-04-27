import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/patient/patient_consultation_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';
import '../../widgets/patient/consultation_card_widget.dart';

class PatientConsultationView
    extends GetView<PatientConsultationController> {
  const PatientConsultationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'Doctor Consultations',
          style: AppFonts.heading3.copyWith(color: AppColors.white),
        ),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.refreshConsultations,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.paddingMedium),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                        controller.upcomingConsultations.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(
                                  AppConstants.paddingLarge),
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusLarge),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 48,
                                    color: AppColors.lightGrey,
                                  ),
                                  const SizedBox(
                                      height: AppConstants.paddingMedium),
                                  Text(
                                    'No upcoming consultations',
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: controller
                                  .upcomingConsultations
                                  .map(
                                  (consultation) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  AppConstants.paddingMedium),
                                          child:
                                              ConsultationCardWidget(
                                      doctorName:
                                        consultation['doctorName'] as String,
                                      specialization:
                                        consultation['specialization'] as String,
                                      dateTime:
                                        '${consultation['date']} - ${consultation['time']}',
                                      status:
                                        consultation['status'] as String,
                                      mode: consultation['mode'] as String,
                                      isHomeTreatment:
                                        consultation['isHomeTreatment'] as bool,
                                      problemSummary:
                                        consultation['problem'] as String,
                                      paymentStatus:
                                        consultation['paymentStatus'] as String,
                                      amountText:
                                        'Rs. ${consultation['amount']}',
                                            onVideoCall:
                                                () =>
                                                    controller
                                                        .startVideoCall(
                                              consultation['id'] as String),
                                            onChat: () =>
                                                controller.openChat(
                                          consultation['id'] as String),
                                            onReschedule:
                                                () =>
                                                    controller.reschedule(
                                            consultation['id'] as String),
                                      onPayNow: (consultation['paymentStatus'] ==
                                          'Pending')
                                        ? () => _openPaymentSheet(
                                            context,
                                            consultation,
                                          )
                                        : null,
                                          ),
                                        ),
                                  )
                                  .toList(),
                            ),
                      const SizedBox(height: AppConstants.paddingLarge),
                      Text(
                        'Completed',
                        style: AppFonts.heading3.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppConstants.paddingMedium),
                      controller.completedConsultations.isEmpty
                          ? Container(
                              padding: const EdgeInsets.all(
                                  AppConstants.paddingLarge),
                              decoration: BoxDecoration(
                                color: AppColors.veryLightGrey,
                                borderRadius: BorderRadius.circular(
                                    AppConstants.borderRadiusLarge),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 48,
                                    color: AppColors.lightGrey,
                                  ),
                                  const SizedBox(
                                      height: AppConstants.paddingMedium),
                                  Text(
                                    'No completed consultations',
                                    style: AppFonts.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Column(
                              children: controller
                                  .completedConsultations
                                  .map(
                                  (consultation) =>
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom:
                                                  AppConstants.paddingMedium),
                                          child:
                                              ConsultationCardWidget(
                                      doctorName:
                                        consultation['doctorName'] as String,
                                      specialization:
                                        consultation['specialization'] as String,
                                      dateTime:
                                        '${consultation['date']} - ${consultation['time']}',
                                      status:
                                        consultation['status'] as String,
                                      mode: consultation['mode'] as String,
                                      isHomeTreatment:
                                        consultation['isHomeTreatment'] as bool,
                                      problemSummary:
                                        consultation['problem'] as String,
                                      paymentStatus:
                                        consultation['paymentStatus'] as String,
                                      amountText:
                                        'Rs. ${consultation['amount']}',
                                            onVideoCall:
                                                () {},
                                            onChat: () =>
                                                controller.openChat(
                                          consultation['id'] as String),
                                            onReschedule:
                                                () {},
                                          ),
                                        ),
                                  )
                                  .toList(),
                            ),
                    ],
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBookingSheet(context),
        backgroundColor: AppColors.primaryBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openBookingSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.82,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Obx(
            () {
              final selectedDoctor = controller.availableDoctors.firstWhereOrNull(
                (doc) => doc['id'] == controller.selectedDoctorId.value,
              );
              final selectedMode = controller.selectedMode.value;
              final estimatedAmount =
                  selectedDoctor == null
                      ? 0
                      : controller.estimateAmount(
                          doctorId: selectedDoctor['id'] as String,
                          mode: selectedMode,
                        );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Doctor Appointment',
                    style: AppFonts.heading3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _buildDropdown(
                    label: 'Select Doctor',
                    value: controller.selectedDoctorId.value,
                    items: controller.availableDoctors
                        .map(
                          (doctor) => DropdownMenuItem<String>(
                            value: doctor['id'] as String,
                            child: Text(
                              '${doctor['name']} (${doctor['specialization']})',
                              style: AppFonts.bodySmall,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => controller.selectedDoctorId.value = value,
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Consultation Type',
                    value: controller.selectedMode.value,
                    items: controller.consultationModes
                        .map(
                          (mode) => DropdownMenuItem<String>(
                            value: mode,
                            child: Text(mode, style: AppFonts.bodySmall),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedMode.value = value;
                      }
                    },
                  ),
                  if (selectedDoctor != null &&
                      selectedMode == 'Home Treatment' &&
                      !(selectedDoctor['supportsHomeTreatment'] as bool))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Selected doctor does not currently support home treatment.',
                        style: AppFonts.bodySmall.copyWith(color: AppColors.error),
                      ),
                    ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        controller.selectedDate.value = date;
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.lightGrey),
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                      child: Text(
                        controller.selectedDate.value == null
                            ? 'Select Preferred Date'
                            : 'Date: ${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                        style: AppFonts.bodySmall.copyWith(
                          color: controller.selectedDate.value == null
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Select Time Slot',
                    value: controller.selectedTimeSlot.value,
                    items: controller.timeSlots
                        .map(
                          (slot) => DropdownMenuItem<String>(
                            value: slot,
                            child: Text(slot, style: AppFonts.bodySmall),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => controller.selectedTimeSlot.value = value,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller.problemController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Explain your problem for doctor review...',
                      hintStyle: AppFonts.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppConstants.borderRadiusMedium),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Payment Gateway Method',
                    value: controller.selectedPaymentMethod.value,
                    items: controller.paymentMethods
                        .map(
                          (method) => DropdownMenuItem<String>(
                            value: method,
                            child: Text(method, style: AppFonts.bodySmall),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.selectedPaymentMethod.value = value;
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Text(
                      'Estimated amount: Rs. $estimatedAmount',
                      style: AppFonts.labelLarge.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final doctorId = controller.selectedDoctorId.value;
                        final date = controller.selectedDate.value;
                        final timeSlot = controller.selectedTimeSlot.value;
                        final problem = controller.problemController.text.trim();

                        if (doctorId == null ||
                            date == null ||
                            timeSlot == null ||
                            problem.isEmpty) {
                          Get.snackbar(
                            'Missing Details',
                            'Please select doctor, mode, date, time, and explain your problem.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        if (selectedDoctor != null &&
                            controller.selectedMode.value == 'Home Treatment' &&
                            !(selectedDoctor['supportsHomeTreatment'] as bool)) {
                          Get.snackbar(
                            'Not Supported',
                            'Please choose virtual mode or another doctor for home treatment.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        controller.createBooking(
                          doctorId: doctorId,
                          mode: controller.selectedMode.value,
                          date: date,
                          timeSlot: timeSlot,
                          problem: problem,
                          paymentMethod: controller.selectedPaymentMethod.value,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Confirm Booking & Pay',
                        style: AppFonts.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _openPaymentSheet(
    BuildContext context,
    Map<String, dynamic> consultation,
  ) {
    String selectedMethod = controller.paymentMethods.first;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (sheetContext, setState) => Container(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Gateway',
                style: AppFonts.heading3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pay Rs. ${consultation['amount']} for ${consultation['doctorName']}',
                style: AppFonts.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              ...controller.paymentMethods.map(
                (method) => RadioListTile<String>(
                  title: Text(method, style: AppFonts.bodySmall),
                  value: method,
                  groupValue: selectedMethod,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedMethod = value);
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.processPayment(
                      consultationId: consultation['id'] as String,
                      paymentMethod: selectedMethod,
                    );
                    Get.back();
                  },
                  icon: const Icon(Icons.lock),
                  label: const Text('Pay Securely'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label, style: AppFonts.bodySmall),
          isExpanded: true,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}

