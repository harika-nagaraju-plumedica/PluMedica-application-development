import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_dashboard_controller.dart';
import '../../models/diagnostics/diagnostics_models.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../widgets/empty_state_widget.dart';
import 'widgets/diagnostics_flow_components.dart';

class DiagnosticsGlobalSearchView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsGlobalSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Search'),
      ),
      body: SafeArea(
        child: Obx(() {
          controller.uiTick.value;
          final results = controller.globalPatientResults;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DiagnosticsSearchBar(
                label: 'Search by: Patient ID / IP No',
                hint: 'Enter Patient ID / IP No',
                controller: controller.globalPatientSearchController,
                onChanged: (_) => controller.notifyUi(),
              ),
              const SizedBox(height: 12),
              if (results.isEmpty)
                const EmptyStateWidget(
                  message: 'No patients found.',
                  icon: Icons.person_search,
                )
              else
                ...results.map(
                  (patient) => DiagnosticsPatientCard(
                    patient: patient,
                    onTap: () {
                      controller.selectFlowPatient(patient);
                      Get.toNamed('/diagnostics/patient-details');
                    },
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

class DiagnosticsPatientDetailsView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsPatientDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: SafeArea(
        child: Obx(() {
          final patient = _selectedPatient();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient Name: ${patient.patientName}', style: AppFonts.labelLarge),
                      const SizedBox(height: 8),
                      Text('IP Number: ${patient.patientId}', style: AppFonts.bodyMedium),
                      const SizedBox(height: 8),
                      Text('Test Performed: ${patient.testRequested}', style: AppFonts.bodyMedium),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DiagnosticsDateFilterChips(
                selected: controller.patientDetailsDateFilter.value,
                onSelected: controller.setPatientDetailsDateFilter,
              ),
            ],
          );
        }),
      ),
    );
  }

  DiagnosticsRequest _selectedPatient() {
    return controller.selectedPatient.value ?? controller.flowPatients.first;
  }
}

class DiagnosticsTestRequestsView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsTestRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Requests'),
      ),
      body: SafeArea(
        child: Obx(() {
          controller.uiTick.value;
          final results = controller.testRequestResults;
          const sourceFilters = <String>[
            'All',
            'Doctor',
            'Hospital',
            'Pharmacy',
            'Patient',
          ];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DiagnosticsSearchBar(
                label: 'Global Search by ID No',
                hint: 'Search ID No',
                controller: controller.testRequestSearchController,
                onChanged: (_) => controller.notifyUi(),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Filter by Source', style: AppFonts.labelLarge),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: sourceFilters
                            .map(
                              (source) => ChoiceChip(
                                label: Text(source),
                                selected:
                                    controller.testRequestSourceFilter.value ==
                                    source,
                                onSelected: (_) =>
                                    controller.setTestRequestSourceFilter(
                                      source,
                                    ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ...results.map(
                (patient) => DiagnosticsPatientCard(
                  patient: patient,
                  onTap: () {
                    controller.selectFlowPatient(patient);
                    Get.toNamed('/diagnostics/test-request-patient');
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class DiagnosticsTestRequestPatientView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsTestRequestPatientView({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = controller.selectedPatient.value ?? controller.flowPatients.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Request Details'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pt Name / IP No', style: AppFonts.labelLarge),
                    const SizedBox(height: 6),
                    Text('${patient.patientName} / ${patient.patientId}'),
                    const SizedBox(height: 12),
                    Text('Tests Requested', style: AppFonts.labelLarge),
                    const SizedBox(height: 6),
                    Text(patient.testRequested),
                    const SizedBox(height: 12),
                    Text('Sample Collection', style: AppFonts.labelLarge),
                    const SizedBox(height: 6),
                    Text(patient.status),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiagnosticsTestsPerformedView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsTestsPerformedView({super.key});

  @override
  Widget build(BuildContext context) {
    final patient = controller.flowPatients.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tests Performed'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pt-1 ID No: ${patient.patientId}', style: AppFonts.labelLarge),
                    const SizedBox(height: 12),
                    _detailRow('Tests Performed', patient.testRequested),
                    _detailRow('Time', '10:30 AM'),
                    _detailRow('Sample Collected', 'Yes'),
                    _detailRow('Report Status', 'Dispatched'),
                    _detailRow('Payment Status', 'Pending'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppFonts.bodyMedium.copyWith(fontWeight: AppFonts.semiBold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class DiagnosticsReportsDispatchedView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsReportsDispatchedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports Dispatched'),
      ),
      body: SafeArea(
        child: Obx(() {
          controller.uiTick.value;
          final results = controller.reportsResults;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DiagnosticsSearchBar(
                label: 'Global Search by ID No',
                hint: 'Search ID No',
                controller: controller.reportsSearchController,
                onChanged: (_) => controller.notifyUi(),
              ),
              const SizedBox(height: 12),
              ...results.map(
                (patient) => DiagnosticsPatientCard(
                  patient: patient,
                  trailingLabel: patient.status == 'Completed' ? 'Dispatched' : 'Pending',
                  onTap: () {},
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class DiagnosticsPaymentReceivedView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsPaymentReceivedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Received'),
      ),
      body: SafeArea(
        child: Obx(() {
          controller.uiTick.value;
          final results = controller.paymentResults;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DiagnosticsDateRangeCard(
                fromController: controller.paymentFromDateController,
                toController: controller.paymentToDateController,
                onPickFrom: () => _pickDate(context, controller.paymentFromDateController),
                onPickTo: () => _pickDate(context, controller.paymentToDateController),
              ),
              const SizedBox(height: 12),
              DiagnosticsSearchBar(
                label: 'Global Search with date range',
                hint: 'Search Patient ID / IP No',
                controller: controller.paymentSearchController,
                onChanged: (_) => controller.notifyUi(),
              ),
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Details', style: AppFonts.labelLarge.copyWith(color: AppColors.primaryDarkBlue)),
                      const SizedBox(height: 10),
                      ...results.map(
                        (patient) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('${patient.patientName} (${patient.patientId})'),
                          subtitle: Text('Payment Details: Received'),
                          trailing: const Icon(Icons.check_circle, color: AppColors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, TextEditingController controller) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(now.year + 2),
      initialDate: now,
    );
    if (date == null) {
      return;
    }
    controller.text = '${date.day}/${date.month}/${date.year}';
    this.controller.notifyUi();
  }
}
