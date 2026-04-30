import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/doctor_referral_flow_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/app_button.dart';
import '../widgets/app_text_field.dart';

class DoctorReferralFormView extends GetView<DoctorReferralFlowController> {
  const DoctorReferralFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Referral Form'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: GetBuilder<DoctorReferralFlowController>(
        builder: (_) {
          final patientResults = controller.patientSearchResults;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.paddingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionCard(
                  title: 'Patient Name & ID',
                  child: Column(
                    children: [
                      AppTextField(
                        label: 'Patient ID',
                        hint: 'Search Patient ID',
                        controller: controller.patientIdController,
                        onChanged: (value) {
                          controller.onPatientIdChanged(value);
                          controller.update();
                        },
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: 'Patient Name',
                        hint: 'Auto-filled or enter manually',
                        controller: controller.patientNameController,
                        onChanged: controller.onPatientNameChanged,
                      ),
                      const SizedBox(height: 8),
                      if (patientResults.isNotEmpty)
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            itemCount: patientResults.length,
                            itemBuilder: (context, index) {
                              final patient = patientResults[index];
                              return ListTile(
                                dense: true,
                                title: Text(
                                  patient['id'] ?? '',
                                  style: AppFonts.bodySmall,
                                ),
                                subtitle: Text(patient['name'] ?? ''),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  controller.selectPatient(patient['id'] ?? '');
                                },
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Doctor Selection Filters',
                  child: Obx(
                    () => Column(
                      children: [
                        DropdownButtonFormField<String>(
                          value: controller.selectedSpecialisation.value,
                          decoration: const InputDecoration(
                            labelText: 'Specialization',
                            border: OutlineInputBorder(),
                          ),
                          items: controller.specialisationOptions
                              .map(
                                (specialisation) => DropdownMenuItem<String>(
                                  value: specialisation,
                                  child: Text(specialisation),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            controller.selectedSpecialisation.value = value;
                            controller.onDoctorFilterChanged();
                          },
                        ),
                        const SizedBox(height: 10),
                        DropdownButtonFormField<String>(
                          value: controller.selectedVisitType.value,
                          decoration: const InputDecoration(
                            labelText: 'Type of Visit',
                            border: OutlineInputBorder(),
                          ),
                          items: DoctorReferralFlowController.visitTypeOptions
                              .map(
                                (visitType) => DropdownMenuItem<String>(
                                  value: visitType,
                                  child: Text(visitType),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedVisitType.value = value;
                              controller.onDoctorFilterChanged();
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          label: 'Consultation Fee',
                          hint: 'Enter max consultation fee',
                          controller: controller.consultationFeeController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => controller.onDoctorFilterChanged(),
                        ),
                        const SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            controller.selectedAvailabilityDate.value == null
                                ? 'Availability Date'
                                : controller.selectedAvailabilityDate.value
                                    .toString()
                                    .split(' ')
                                    .first,
                          ),
                          trailing: const Icon(Icons.calendar_today),
                          onTap: () async {
                            await controller.pickAvailabilityDate(context);
                            controller.onDoctorFilterChanged();
                          },
                        ),
                        if (controller.selectedDoctorData != null) ...[
                          const SizedBox(height: 10),
                          Card(
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              dense: true,
                              title: Text(
                                'Auto-selected: ${controller.selectedDoctorData!['name']} (${controller.selectedDoctorData!['id']})',
                              ),
                              subtitle: Text(
                                '${controller.selectedDoctorData!['specialization']} • Rs. ${controller.selectedDoctorData!['fee']}',
                              ),
                              trailing: const Icon(Icons.check_circle, color: AppColors.green),
                            ),
                          ),
                        ],
                        if (controller.hasDoctorFilterInput) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Matching Doctors',
                              style: AppFonts.labelLarge,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (controller.filteredDoctors.isEmpty)
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text('No matching doctors for current filters.'),
                            )
                          else
                            ...controller.filteredDoctors
                                .take(3)
                                .map(
                                  (doctor) => Card(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        '${doctor['name']} (${doctor['id']})',
                                      ),
                                      subtitle: Text(
                                        '${doctor['specialization']} • Rs. ${doctor['fee']}',
                                      ),
                                      trailing: const Icon(Icons.check_circle_outline),
                                      onTap: () =>
                                          controller.selectDoctorFromSuggestion(doctor),
                                    ),
                                  ),
                                ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Reason for Ref',
                  child: AppTextField(
                    label: 'Reason for Ref',
                    hint: 'Enter reason',
                    controller: controller.reasonForRefController,
                  ),
                ),
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Description',
                  child: AppTextField(
                    label: 'Description',
                    hint: 'Enter description',
                    controller: controller.descriptionController,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Search Available Doctors',
                        onPressed: controller.submitReferralForm,
                        width: double.infinity,
                        height: 46,
                        backgroundColor: AppColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppButton(
                        text: 'Submit Referral',
                        onPressed: controller.submitReferral,
                        width: double.infinity,
                        height: 46,
                        backgroundColor: AppColors.primaryDarkBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DoctorReferralSearchView extends GetView<DoctorReferralFlowController> {
  const DoctorReferralSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Doctor Search & Filter'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 760;
            return Column(
              children: [
                if (isNarrow) ...[
                  _leftSection(),
                  const SizedBox(height: 12),
                  _rightSection(context),
                ] else
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _leftSection()),
                      const SizedBox(width: 12),
                      Expanded(child: _rightSection(context)),
                    ],
                  ),
                const SizedBox(height: 16),
                AppButton(
                  text: 'Search',
                  onPressed: controller.searchDoctors,
                  width: double.infinity,
                  height: 46,
                  backgroundColor: AppColors.primaryDarkBlue,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _leftSection() {
    return _SectionCard(
      title: 'Filters',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedSpecialisation.value,
              decoration: const InputDecoration(
                labelText: 'Specialisation',
                border: OutlineInputBorder(),
              ),
              items: controller.specialisationOptions
                  .map(
                    (specialisation) => DropdownMenuItem<String>(
                      value: specialisation,
                      child: Text(specialisation),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                controller.selectedSpecialisation.value = value;
                controller.onDoctorFilterChanged();
              },
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => DropdownButtonFormField<String>(
              value: controller.selectedVisitType.value,
              decoration: const InputDecoration(
                labelText: 'Type of Visit',
                border: OutlineInputBorder(),
              ),
              items: DoctorReferralFlowController.visitTypeOptions
                  .map(
                    (visitType) => DropdownMenuItem<String>(
                      value: visitType,
                      child: Text(visitType),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  controller.selectedVisitType.value = value;
                  controller.onDoctorFilterChanged();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightSection(BuildContext context) {
    return _SectionCard(
      title: 'Search Criteria',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            label: 'Consultation Fee',
            hint: 'Enter max fee',
            controller: controller.consultationFeeController,
            keyboardType: TextInputType.number,
            onChanged: (_) => controller.onDoctorFilterChanged(),
          ),
          const SizedBox(height: 12),
          Text('Availability', style: AppFonts.labelLarge),
          const SizedBox(height: 6),
          Obx(
            () => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                controller.selectedAvailabilityDate.value == null
                    ? 'Select date'
                    : controller.selectedAvailabilityDate.value
                        .toString()
                        .split(' ')
                        .first,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                await controller.pickAvailabilityDate(context);
                controller.onDoctorFilterChanged();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorReferralListView extends GetView<DoctorReferralFlowController> {
  const DoctorReferralListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('List of Doctors'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(() {
        final doctors = controller.filteredDoctors;
        if (doctors.isEmpty) {
          return Center(
            child: Text(
              'No doctors found for selected filters.',
              style: AppFonts.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index];
            final doctorId = (doctor['id'] ?? '').toString();
            final freeSlots = controller.slotsForDoctor(doctorId);
            return _DoctorCard(
              doctor: doctor,
              selectedDoctorId: controller.selectedDoctorId.value,
              selectedTimeSlot: controller.selectedDoctorId.value == doctorId
                  ? controller.selectedTimeSlot.value
                  : null,
              slots: freeSlots,
              onSelectDoctor: () {
                controller.selectedDoctorId.value = doctorId;
                controller.selectedTimeSlot.value = null;
                controller.autofillDoctorDetailsFromId(doctorId);
              },
              onSelectTimeSlot: (value) {
                controller.selectedDoctorId.value = doctorId;
                controller.selectedTimeSlot.value = value;
                controller.autofillDoctorDetailsFromId(doctorId);
                controller.selectedTimeSlot.value = value;
              },
              onContinue: controller.proceedToConfirmation,
            );
          },
        );
      }),
    );
  }
}

class DoctorReferralConfirmationView
    extends GetView<DoctorReferralFlowController> {
  const DoctorReferralConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Confirmation'),
        backgroundColor: AppColors.primaryDarkBlue,
      ),
      body: Obx(() {
        final doctor = controller.selectedDoctorData;
        final patientId = controller.patientIdController.text.trim();
        final reason = controller.reasonForRefController.text.trim();
        final requestedDate = controller.selectedAvailabilityDate.value
          ?.toString()
          .split(' ')
          .first;

        if (doctor == null) {
          return Center(
            child: Text('No doctor selected.', style: AppFonts.bodyMedium),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            children: [
              _SectionCard(
                title: 'Review Referral',
                child: Column(
                  children: [
                    _InfoRow(
                      label: 'Selected Doctor',
                      value: (doctor['name'] ?? '').toString(),
                    ),
                    _InfoRow(
                      label: 'Visit Type',
                      value: controller.selectedVisitType.value,
                    ),
                    _InfoRow(
                      label: 'Requested Date',
                      value: requestedDate ?? '-',
                    ),
                    _InfoRow(
                      label: 'Time Slot',
                      value: controller.selectedTimeSlot.value ?? '-',
                    ),
                    _InfoRow(label: 'Patient ID', value: patientId),
                    _InfoRow(label: 'Referral Reason', value: reason),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Submit Referral',
                onPressed: controller.confirmReferral,
                width: double.infinity,
                height: 46,
                backgroundColor: AppColors.primaryDarkBlue,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.labelLarge),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final String? selectedDoctorId;
  final String? selectedTimeSlot;
  final List<String> slots;
  final VoidCallback onSelectDoctor;
  final ValueChanged<String?> onSelectTimeSlot;
  final VoidCallback onContinue;

  const _DoctorCard({
    required this.doctor,
    required this.selectedDoctorId,
    required this.selectedTimeSlot,
    required this.slots,
    required this.onSelectDoctor,
    required this.onSelectTimeSlot,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final doctorId = (doctor['id'] ?? '').toString();
    final isSelected = selectedDoctorId == doctorId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(AppConstants.paddingMedium),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.lightGrey,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doctor Name: ${(doctor['name'] ?? '').toString()}',
            style: AppFonts.labelLarge,
          ),
          const SizedBox(height: 4),
          Text('Doctor ID: $doctorId', style: AppFonts.bodySmall),
          const SizedBox(height: 4),
          Text(
            'Specialisation: ${(doctor['specialization'] ?? '').toString()}',
            style: AppFonts.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Experience: ${(doctor['experience'] ?? 0)} years',
            style: AppFonts.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Consultation Fee: Rs. ${(doctor['fee'] ?? 0)}',
            style: AppFonts.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Rating / Reviews: ${doctor['rating']} (${doctor['reviews']})',
            style: AppFonts.bodySmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onSelectDoctor,
                  child: const Text('Select'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: isSelected ? selectedTimeSlot : null,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Time Slot',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: slots
                      .map(
                        (slot) => DropdownMenuItem<String>(
                          value: slot,
                          child: Text(slot, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: slots.isEmpty ? null : onSelectTimeSlot,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppButton(
            text: 'Send Request',
            onPressed: isSelected ? onContinue : onSelectDoctor,
            width: double.infinity,
            height: 42,
            backgroundColor: AppColors.primaryDarkBlue,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppFonts.bodySmall.copyWith(fontWeight: AppFonts.semiBold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 3, child: Text(value, style: AppFonts.bodySmall)),
        ],
      ),
    );
  }
}
