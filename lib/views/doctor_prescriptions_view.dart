import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/doctor_prescriptions_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

/// Doctor Prescriptions View
class DoctorPrescriptionsView extends GetView<DoctorPrescriptionsController> {
  const DoctorPrescriptionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text('Prescriptions'),
          backgroundColor: AppColors.primaryDarkBlue,
          elevation: 0,
          bottom: TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withOpacity(0.6),
            indicatorColor: AppColors.white,
            tabs: const [
              Tab(text: 'New Prescription'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    // New Prescription Tab
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(
                        AppConstants.paddingMedium,
                      ),
                      child: Form(
                        key: controller.prescriptionFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Patient ID
                            AppTextField(
                              label: 'Patient ID',
                              hint: 'Enter patient ID',
                              controller: controller.patientIdController,
                              required: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Patient ID is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Medication Name
                            AppTextField(
                              label: 'Medication Name',
                              hint: 'Enter medication name',
                              controller: controller.medicationController,
                              required: true,
                              validator:
                                  controller.validateMedicationName,
                            ),
                            const SizedBox(height: 16),

                            // Dosage
                            AppTextField(
                              label: 'Dosage',
                              hint: 'e.g., 500mg',
                              controller: controller.dosageController,
                              required: true,
                              validator: controller.validateDosage,
                            ),
                            const SizedBox(height: 16),

                            // Frequency
                            Text(
                              'Frequency *',
                              style: AppFonts.labelLarge.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppConstants.paddingMedium,
                                vertical: AppConstants.paddingSmall,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: AppColors.lightGrey),
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadiusMedium,
                                ),
                              ),
                              child: Obx(
                                () => DropdownButton<String>(
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  hint: const Text('Select Frequency'),
                                  value: controller.selectedFrequency.value,
                                  items: controller.frequencyOptions
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.selectedFrequency.value =
                                          newValue;
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Duration
                            AppTextField(
                              label: 'Duration (Days)',
                              hint: 'e.g., 7',
                              controller: controller.durationController,
                              keyboardType: TextInputType.number,
                              required: true,
                              validator: controller.validateDuration,
                            ),
                            const SizedBox(height: 16),

                            // Instructions
                            AppTextField(
                              label: 'Instructions',
                              hint:
                                  'e.g., Take after meals, avoid alcohol',
                              controller: controller.instructionsController,
                              required: true,
                              maxLines: 3,
                              validator: controller.validateInstructions,
                            ),
                            const SizedBox(height: 24),

                            // Save Button
                            Obx(
                              () => AppButton(
                                text: 'Save Prescription',
                                onPressed:
                                    controller.savePrescription,
                                isLoading: controller.isLoading.value,
                                width: double.infinity,
                                height: 50,
                                backgroundColor:
                                    AppColors.primaryDarkBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // History Tab
                    Obx(
                      () => controller.prescriptions.isEmpty
                          ? Center(
                              child: Text(
                                'No prescriptions issued',
                                style: AppFonts.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            )
                          : ListView(
                              padding: const EdgeInsets.all(
                                AppConstants.paddingMedium,
                              ),
                              children: controller.prescriptions
                                  .map(
                                    (prescription) =>
                                        GestureDetector(
                                      // TODO: Implement prescription details view
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
                                                        prescription
                                                            .medicationName,
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
                                                        '${prescription.dosage} - ${prescription.frequency}',
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
                                                    color: AppColors.success
                                                        .withOpacity(0.2),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(12),
                                                  ),
                                                  child: Text(
                                                    'Active',
                                                    style: AppFonts
                                                        .labelSmall
                                                        .copyWith(
                                                      color:
                                                          AppColors.success,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
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
                                                  prescription.createdAt
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
