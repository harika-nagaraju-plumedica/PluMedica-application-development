import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/diagnostics/diagnostics_dashboard_controller.dart';
import '../../models/diagnostics/diagnostics_models.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/fonts.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/loading_state_widget.dart';
import 'widgets/diagnostics_patient_search_panel.dart';
import 'widgets/diagnostics_report_payment_panel.dart';
import 'widgets/diagnostics_request_table.dart';
import 'widgets/diagnostics_sidebar.dart';
import 'widgets/diagnostics_test_entry_form.dart';
import 'widgets/diagnostics_top_header.dart';
import 'widgets/diagnostics_ui_components.dart';

class DiagnosticsDashboardView extends GetView<DiagnosticsDashboardController> {
  const DiagnosticsDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 1040;
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8FD),
      drawer: isDesktop
          ? null
          : Drawer(child: DiagnosticsSidebar(controller: controller)),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop)
              SizedBox(
                width: 280,
                child: DiagnosticsSidebar(controller: controller),
              ),
            Expanded(
              child: Column(
                children: [
                  DiagnosticsTopHeader(
                    controller: controller,
                    isDesktop: isDesktop,
                  ),
                  Expanded(
                    child: Obx(
                      () => controller.isLoading.value
                          ? const LoadingStateWidget(
                              message: 'Loading diagnostics module...',
                            )
                          : _buildScreenBody(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenBody(BuildContext context) {
    return Obx(() {
      controller.uiTick.value;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: AnimatedSwitcher(
          duration: AppConstants.animationDuration,
          child: switch (controller.selectedMenu.value) {
            0 => _buildDiagnosticsOverview(context),
            1 => _buildTestRequestList(context),
            2 => _buildPatientSearchSelection(),
            3 => _buildTestDetailsEntry(context),
            4 => _buildReportAndPayment(context),
            _ => _buildDateFilteredReports(context),
          },
        ),
      );
    });
  }

  Widget _buildDiagnosticsOverview(BuildContext context) {
    final filtered = controller.globalResults;
    final performedCount = filtered
        .where((e) => e.status == 'In Progress' || e.status == 'Completed')
        .length;
    final reportCount = filtered.where((e) => e.status == 'Completed').length;

    return Column(
      key: const ValueKey<String>('dashboard'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DiagnosticsSummaryCard(
              title: 'Test Requests',
              value: filtered.length.toString(),
              icon: Icons.request_page,
              color: AppColors.primaryBlue,
            ),
            DiagnosticsSummaryCard(
              title: 'Tests Performed',
              value: performedCount.toString(),
              icon: Icons.science,
              color: AppColors.warning,
            ),
            DiagnosticsSummaryCard(
              title: 'Reports Dispatched',
              value: reportCount.toString(),
              icon: Icons.picture_as_pdf,
              color: AppColors.green,
            ),
            DiagnosticsSummaryCard(
              title: 'Payments Received',
              value: '₹ 24,500',
              icon: Icons.payments,
              color: AppColors.primaryDarkBlue,
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Filters', style: AppFonts.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: ['Day', 'Month', 'Year']
                      .map(
                        (item) => ChoiceChip(
                          label: Text(item),
                          selected: controller.dateQuickFilter.value == item,
                          onSelected: (_) =>
                              controller.setDateQuickFilter(item),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCrossModuleLinks(),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recent Activity', style: AppFonts.labelLarge),
                const SizedBox(height: 8),
                if (controller.recentActivity.isEmpty)
                  const EmptyStateWidget(
                    message: 'No recent activity yet.',
                    icon: Icons.timeline,
                  )
                else
                  ...controller.recentActivity.map(
                    (item) => ListTile(
                      dense: true,
                      leading: const Icon(
                        Icons.bolt,
                        color: AppColors.primaryBlue,
                      ),
                      title: Text(item.event),
                      subtitle: Text(item.time),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTestRequestList(BuildContext context) {
    return DiagnosticsRequestTable(
      key: const ValueKey<String>('requests'),
      rows: controller.globalResults,
      onView: (row) => _showRequestDetails(context, row),
      onStatusChange: controller.updateRequestStatus,
    );
  }

  Widget _buildPatientSearchSelection() {
    return DiagnosticsPatientSearchPanel(
      key: const ValueKey<String>('patient_search'),
      searchController: controller.patientSearchController,
      results: controller.searchResults,
      onSearchChanged: (_) => controller.notifyUi(),
      onSelect: controller.selectPatient,
    );
  }

  Widget _buildTestDetailsEntry(BuildContext context) {
    final patient =
        controller.selectedPatient.value ?? controller.testRequests.first;
    return DiagnosticsTestEntryForm(
      key: const ValueKey<String>('test_entry'),
      patient: patient,
      status: controller.selectedStatus.value,
      selectedTestPerformed: controller.selectedTestPerformed.value,
      sampleCollected: controller.sampleCollected.value,
      collectionDate: controller.collectionDate.value,
      notesController: controller.notesController,
      uploadTile: _uploadReportTile(),
      onTestPerformedChanged: controller.setSelectedTestPerformed,
      onSampleCollectedChanged: controller.setSampleCollected,
      onPickCollectionDate: () => _pickCollectionDate(context),
      onSave: controller.saveProgress,
      onMarkCompleted: controller.markCompleted,
    );
  }

  Widget _buildReportAndPayment(BuildContext context) {
    return DiagnosticsReportPaymentPanel(
      key: const ValueKey<String>('report_payment'),
      uploadedReportName: controller.uploadedReportName.value,
      testCostController: controller.testCostController,
      paymentStatus: controller.paymentStatus.value,
      paymentMethod: controller.paymentMethod.value,
      onPaymentStatusChanged: controller.setPaymentStatus,
      onPaymentMethodChanged: controller.setPaymentMethod,
      onGenerateInvoice: controller.generateInvoice,
      onPreviewReport: () => Get.defaultDialog(
        title: 'Report Preview',
        middleText:
            'Showing report preview for ${controller.uploadedReportName.value}',
        textConfirm: 'OK',
        onConfirm: Get.back,
      ),
      onDownloadReport: () => Get.snackbar(
        'Download',
        'Report download started.',
        snackPosition: SnackPosition.BOTTOM,
      ),
    );
  }

  Widget _buildDateFilteredReports(BuildContext context) {
    final reports = controller.reportFilteredResults;
    return Column(
      key: const ValueKey<String>('date_filtered_reports'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From - To Date Filters', style: AppFonts.labelLarge),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.fromDateController,
                        readOnly: true,
                        onTap: () => _pickFilterDate(
                          context,
                          controller.fromDateController,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'From Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: controller.toDateController,
                        readOnly: true,
                        onTap: () => _pickFilterDate(
                          context,
                          controller.toDateController,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'To Date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.patientFilterController,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Patient',
                  ),
                  onChanged: (_) => controller.notifyUi(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.doctorFilterController,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Doctor',
                  ),
                  onChanged: (_) => controller.notifyUi(),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: controller.testFilterController,
                  decoration: const InputDecoration(
                    labelText: 'Filter by Test Type',
                  ),
                  onChanged: (_) => controller.notifyUi(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DiagnosticsSummaryCard(
              title: 'Total Tests',
              value: reports.length.toString(),
              icon: Icons.monitor_heart,
              color: AppColors.primaryBlue,
            ),
            DiagnosticsSummaryCard(
              title: 'Total Revenue',
              value: '₹ ${(reports.length * 1200)}',
              icon: Icons.currency_rupee,
              color: AppColors.green,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (reports.isEmpty)
          const EmptyStateWidget(
            message: 'No records found for selected filters.',
            icon: Icons.filter_alt_off,
          )
        else
          ...reports.map(
            (row) => Card(
              child: ListTile(
                title: Text('${row.patientName} - ${row.testRequested}'),
                subtitle: Text('Doctor: ${row.doctorName} | Date: ${row.date}'),
                trailing: DiagnosticsStatusBadge(status: row.status),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCrossModuleLinks() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Linking with Other Modules', style: AppFonts.labelLarge),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DiagnosticsModuleLinkButton(
                  label: 'Doctor: Request Test',
                  icon: Icons.add_task,
                  onTap: () => controller.setMenu(1),
                ),
                DiagnosticsModuleLinkButton(
                  label: 'Doctor: View Reports',
                  icon: Icons.visibility,
                  onTap: () => controller.setMenu(4),
                ),
                DiagnosticsModuleLinkButton(
                  label: 'Patient: Test Status',
                  icon: Icons.timeline,
                  onTap: () => controller.setMenu(2),
                ),
                DiagnosticsModuleLinkButton(
                  label: 'Patient: Download Reports',
                  icon: Icons.download,
                  onTap: () => controller.setMenu(4),
                ),
                DiagnosticsModuleLinkButton(
                  label: 'Pharmacy: Prescribed Diagnostics',
                  icon: Icons.medication,
                  onTap: () => Get.defaultDialog(
                    title: 'Pharmacy Link',
                    middleText: 'Optional pharmacy diagnostics view opened.',
                    textConfirm: 'OK',
                    onConfirm: Get.back,
                  ),
                ),
                DiagnosticsModuleLinkButton(
                  label: 'Hospital: Bulk Requests',
                  icon: Icons.local_hospital,
                  onTap: () => Get.defaultDialog(
                    title: 'Bulk Requests',
                    middleText: 'Hospital bulk test request intake opened.',
                    textConfirm: 'OK',
                    onConfirm: Get.back,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _uploadReportTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        children: [
          const Icon(Icons.upload_file, color: AppColors.primaryBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Obx(
              () => Text(
                controller.uploadedReportName.value.isEmpty
                    ? 'Upload Reports (file upload)'
                    : controller.uploadedReportName.value,
              ),
            ),
          ),
          TextButton(
            onPressed: controller.uploadMockReport,
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickCollectionDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(now.year + 2),
      initialDate: controller.collectionDate.value ?? now,
    );
    if (date == null) {
      return;
    }
    controller.collectionDate.value = date;
  }

  Future<void> _pickFilterDate(
    BuildContext context,
    TextEditingController target,
  ) async {
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
    target.text = '${date.day}/${date.month}/${date.year}';
    controller.notifyUi();
  }

  void _showRequestDetails(BuildContext context, DiagnosticsRequest row) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Test Request Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${row.patientName} (${row.patientId})'),
            const SizedBox(height: 6),
            Text('Doctor: ${row.doctorName}'),
            const SizedBox(height: 6),
            Text('Source: ${row.source}'),
            const SizedBox(height: 6),
            Text('Test: ${row.testRequested}'),
            const SizedBox(height: 6),
            Row(
              children: [
                const Text('Status: '),
                DiagnosticsStatusBadge(status: row.status),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.selectPatient(row);
            },
            child: const Text('Open Test Entry'),
          ),
        ],
      ),
    );
  }
}
