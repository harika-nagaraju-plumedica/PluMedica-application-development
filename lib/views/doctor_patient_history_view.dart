import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_patient_history_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';

/// Doctor Patient History View
class DoctorPatientHistoryView
    extends GetView<DoctorPatientHistoryController> {
  const DoctorPatientHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Patient History'),
        backgroundColor: AppColors.primaryDarkBlue,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    // Filter Section
                    Container(
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

                          // Patient Filter
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('Select Patient'),
                              value: controller.selectedPatient.value,
                              items: controller.patientList
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: controller.filterByPatient,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Year Filter
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.paddingMedium,
                              vertical: AppConstants.paddingSmall,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.lightGrey),
                              borderRadius: BorderRadius.circular(
                                AppConstants.borderRadiusMedium,
                              ),
                            ),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: const SizedBox(),
                              hint: const Text('Select Year'),
                              value: controller.selectedYear.value,
                              items: controller.yearList.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: controller.filterByYear,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Clear Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.clearFilters,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.lightGrey,
                              ),
                              child: const Text('Clear Filters'),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Results Section
                    Padding(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      child: Obx(
                        () => controller.filteredHistoryList.isEmpty
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.history,
                                      size: 48,
                                      color: AppColors.lightGrey,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'No patient history found',
                                      style: AppFonts.bodyMedium.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: controller.filteredHistoryList
                                    .map(
                                      (history) =>
                                          GestureDetector(
                                        // TODO: Implement patient details view
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
                                              Text(
                                                history.patientName,
                                                style: AppFonts.labelLarge
                                                    .copyWith(
                                                  color:
                                                      AppColors.textPrimary,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Diagnosis: ${history.diagnosis}',
                                                style: AppFonts.bodySmall
                                                    .copyWith(
                                                  color:
                                                      AppColors.textSecondary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(
                                                    Icons.calendar_today,
                                                    size: AppConstants
                                                        .iconSizeSmall,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                    history.visitDate
                                                        .toString()
                                                        .split(' ')[0],
                                                    style: AppFonts.bodySmall
                                                        .copyWith(
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 12),
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(
                                                  Icons.chevron_right,
                                                  color:
                                                      AppColors.primaryBlue,
                                                ),
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
                  ],
                ),
              ),
      ),
    );
  }
}
