import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/doctor_prescriptions_controller.dart';
import '../models/prescription_model.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class DoctorPrescriptionsView extends GetView<DoctorPrescriptionsController> {
  const DoctorPrescriptionsView({super.key});

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
          actions: [
            IconButton(
              tooltip: 'Refer Doctor',
              onPressed: () => _openReferralSheet(
                patientId: controller.patientIdController.text.trim().isEmpty
                    ? 'P1'
                    : controller.patientIdController.text.trim(),
                patientName: controller.patientNameController.text.trim().isEmpty
                    ? 'Current Patient'
                    : controller.patientNameController.text.trim(),
              ),
              icon: const Icon(Icons.forward_to_inbox_outlined),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.white,
            unselectedLabelColor: AppColors.white.withOpacity(0.6),
            indicatorColor: AppColors.white,
            tabs: const [
              Tab(text: 'Create Prescription'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(AppConstants.paddingMedium),
                      child: Form(
                        key: controller.prescriptionFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                            AppTextField(
                              label: 'Patient Name',
                              hint: 'Enter patient name',
                              controller: controller.patientNameController,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Patient name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Drug Entries',
                                  style: AppFonts.labelLarge.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: controller.addDrugEntry,
                                  icon: const Icon(Icons.add),
                                  label: const Text('Add Drug'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Obx(
                              () => Column(
                                children: controller.drugForms
                                    .asMap()
                                    .entries
                                    .map((entry) {
                                  final index = entry.key;
                                  final drugForm = entry.value;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      border: Border.all(color: AppColors.lightGrey),
                                      borderRadius: BorderRadius.circular(
                                        AppConstants.borderRadiusMedium,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Drug ${index + 1}',
                                              style: AppFonts.labelLarge,
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () =>
                                                  controller.removeDrugEntry(index),
                                              icon: const Icon(Icons.delete_outline),
                                            ),
                                          ],
                                        ),
                                        AppTextField(
                                          label: 'Drug Name',
                                          hint: 'Enter drug name',
                                          controller: drugForm.drugNameController,
                                          required: true,
                                        ),
                                        const SizedBox(height: 12),
                                        AppTextField(
                                          label: 'Dosage',
                                          hint: 'e.g., 500mg',
                                          controller: drugForm.dosageController,
                                          required: true,
                                        ),
                                        const SizedBox(height: 12),
                                        AppTextField(
                                          label: 'Duration (days)',
                                          hint: 'e.g., 7',
                                          controller: drugForm.durationController,
                                          keyboardType: TextInputType.number,
                                          required: true,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          'Timing *',
                                          style: AppFonts.labelLarge.copyWith(
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        Obx(
                                          () => Wrap(
                                            spacing: 8,
                                            children: [
                                              FilterChip(
                                                label: const Text('Morning'),
                                                selected: drugForm.morning.value,
                                                onSelected: (v) {
                                                  drugForm.morning.value = v;
                                                },
                                              ),
                                              FilterChip(
                                                label: const Text('Afternoon'),
                                                selected: drugForm.afternoon.value,
                                                onSelected: (v) {
                                                  drugForm.afternoon.value = v;
                                                },
                                              ),
                                              FilterChip(
                                                label: const Text('Night'),
                                                selected: drugForm.night.value,
                                                onSelected: (v) {
                                                  drugForm.night.value = v;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        AppTextField(
                                          label: 'Instructions / Notes',
                                          hint: 'Take after meal, avoid driving, etc.',
                                          controller: drugForm.instructionsController,
                                          required: true,
                                          maxLines: 2,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppTextField(
                              label: 'Remarks / Notes',
                              hint: 'Overall remarks for this prescription',
                              controller: controller.remarksController,
                              maxLines: 3,
                            ),
                            const SizedBox(height: 24),
                            Obx(
                              () => AppButton(
                                text: 'Save Prescription',
                                onPressed: controller.savePrescription,
                                isLoading: controller.isLoading.value,
                                width: double.infinity,
                                height: 50,
                                backgroundColor: AppColors.primaryDarkBlue,
                              ),
                            ),
                            const SizedBox(height: 8),
                            AppButton(
                              text: 'Refer Doctor',
                              onPressed: () => _openReferralSheet(
                                patientId: controller.patientIdController.text.trim().isEmpty
                                    ? 'P1'
                                    : controller.patientIdController.text.trim(),
                                patientName: controller
                                        .patientNameController.text.trim().isEmpty
                                    ? 'Current Patient'
                                    : controller.patientNameController.text.trim(),
                              ),
                              width: double.infinity,
                              height: 46,
                              backgroundColor: AppColors.warning,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                                  .map((prescription) => _historyCard(prescription))
                                  .toList(),
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _historyCard(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${prescription.patientName.isEmpty ? prescription.patientId : prescription.patientName} • ${prescription.id}',
                  style: AppFonts.labelLarge.copyWith(color: AppColors.textPrimary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Active',
                  style: AppFonts.labelSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...prescription.drugEntries.map(
            (drug) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${drug.drugName} | ${drug.dosage} | ${drug.durationDays} days | ${_timings(drug)}',
                style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
          if (prescription.remarks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Remarks: ${prescription.remarks}',
                style: AppFonts.bodySmall.copyWith(color: AppColors.textPrimary),
              ),
            ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _openFollowUpSheet(prescription),
                  child: const Text('Add Follow-up'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _openReferralSheet(
                    patientId: prescription.patientId,
                    patientName: prescription.patientName,
                  ),
                  child: const Text('Refer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _timings(DrugEntry entry) {
    final timings = <String>[];
    if (entry.morning) timings.add('Morning');
    if (entry.afternoon) timings.add('Afternoon');
    if (entry.night) timings.add('Night');
    return timings.join('/');
  }

  void _openFollowUpSheet(Prescription prescription) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Follow-up', style: AppFonts.heading3),
            const SizedBox(height: 8),
            Text(
              'Previous Prescription: ${prescription.id} (Read-only)',
              style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Notes / Progress Update',
              hint: 'Enter notes',
              controller: controller.followUpNotesController,
              maxLines: 3,
              required: true,
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Updated Medication (Optional)',
              hint: 'Enter updates',
              controller: controller.followUpUpdatedMedicationController,
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Next Visit Date'),
              subtitle: Obx(
                () => Text(
                  controller.selectedFollowUpDate.value == null
                      ? 'Select date'
                      : controller.selectedFollowUpDate.value
                          .toString()
                          .split(' ')
                          .first,
                ),
              ),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final date = await showDatePicker(
                  context: Get.context!,
                  initialDate: DateTime.now().add(const Duration(days: 7)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 180)),
                );
                if (date != null) {
                  controller.selectedFollowUpDate.value = date;
                }
              },
            ),
            const SizedBox(height: 8),
            AppButton(
              text: 'Save Follow-up',
              onPressed: () => controller.addFollowUp(prescription: prescription),
              width: double.infinity,
              height: 46,
              backgroundColor: AppColors.primaryDarkBlue,
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _openReferralSheet({
    required String patientId,
    required String patientName,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Refer Doctor', style: AppFonts.heading3),
              const SizedBox(height: 10),
              Text(
                'Patient: $patientName ($patientId)',
                style: AppFonts.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 10),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedReferredDoctorId.value,
                  decoration: const InputDecoration(
                    labelText: 'Select Doctor ID (mandatory)',
                    border: OutlineInputBorder(),
                  ),
                  items: controller.referralDoctorOptions
                      .map(
                        (doctor) => DropdownMenuItem<String>(
                          value: doctor['id'] as String,
                          child: Text(
                            '${doctor['id']} - ${doctor['name']}',
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedReferredDoctorId.value = value;
                  },
                ),
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Reason for referral',
                hint: 'Enter reason',
                controller: controller.referralReasonController,
                required: true,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Detailed Description',
                hint: 'Add details for referred doctor',
                controller: controller.referralDescriptionController,
                required: true,
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'File/Image Attachment (Optional)',
                hint: 'e.g., ecg_report.png',
                controller: controller.referralAttachmentController,
              ),
              const SizedBox(height: 12),
              AppButton(
                text: 'Refer',
                onPressed: () => controller.submitReferral(
                  patientId: patientId,
                  patientName: patientName,
                ),
                width: double.infinity,
                height: 46,
                backgroundColor: AppColors.warning,
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
