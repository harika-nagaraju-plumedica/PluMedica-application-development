import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/diagnostics/diagnostics_models.dart';

class DiagnosticsDashboardController extends GetxController {
  static const menus = <String>[
    'Diagnostics Dashboard',
    'Test Request List',
    'Patient Search',
    'Test Details Entry',
    'Report & Payment',
    'Date Filtered Reports',
  ];

  final selectedMenu = 0.obs;
  final isLoading = true.obs;
  final sampleCollected = false.obs;
  final dateQuickFilter = 'Day'.obs;
  final selectedStatus = 'Requested'.obs;
  final paymentStatus = 'Pending'.obs;
  final paymentMethod = 'UPI'.obs;
  final selectedTestPerformed = 'CBC'.obs;
  final collectionDate = Rxn<DateTime>();
  final uploadedReportName = ''.obs;
  final notes = ''.obs;
  final uiTick = 0.obs;

  final globalSearchController = TextEditingController();
  final patientSearchController = TextEditingController();
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final doctorFilterController = TextEditingController();
  final patientFilterController = TextEditingController();
  final testFilterController = TextEditingController();
  final testCostController = TextEditingController(text: '1200');
  final notesController = TextEditingController();

  final testRequests = <DiagnosticsRequest>[
    DiagnosticsRequest(
      patientName: 'Rajesh Kumar',
      patientId: 'PAT-0001',
      doctorName: 'Dr. Priya Sharma',
      source: 'Doctor',
      testRequested: 'Complete Blood Count',
      status: 'Requested',
      mobile: '9876543210',
      date: '29 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Priya Singh',
      patientId: 'PAT-0002',
      doctorName: 'Dr. Amit Patel',
      source: 'Hospital',
      testRequested: 'Lipid Profile',
      status: 'Sample Collected',
      mobile: '9812345678',
      date: '29 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Amit Verma',
      patientId: 'PAT-0003',
      doctorName: 'Dr. Nisha Verma',
      source: 'Hospital',
      testRequested: 'Thyroid Panel',
      status: 'In Progress',
      mobile: '9799999999',
      date: '28 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Neha Gupta',
      patientId: 'PAT-0004',
      doctorName: 'Dr. Harish Menon',
      source: 'Doctor',
      testRequested: 'Liver Function Test',
      status: 'Completed',
      mobile: '9765432101',
      date: '28 Apr 2026',
    ),
  ].obs;

  final recentActivity = const <DiagnosticsActivity>[
    DiagnosticsActivity(
      time: '10:35 AM',
      event: 'Sample collected for PAT-0002',
    ),
    DiagnosticsActivity(
      time: '09:20 AM',
      event: 'New request received from Plumedica Hospital',
    ),
    DiagnosticsActivity(
      time: '08:55 AM',
      event: 'Report dispatched to Dr. Priya Sharma',
    ),
    DiagnosticsActivity(
      time: 'Yesterday',
      event: 'Payment received for invoice INV-2026-042',
    ),
  ].obs;

  final selectedPatient = Rxn<DiagnosticsRequest>();

  List<DiagnosticsRequest> get searchResults {
    final query = patientSearchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return testRequests.take(3).toList();
    }
    return testRequests
        .where(
          (patient) =>
              patient.patientName.toLowerCase().contains(query) ||
              patient.patientId.toLowerCase().contains(query),
        )
        .toList();
  }

  List<DiagnosticsRequest> get globalResults {
    final query = globalSearchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return testRequests;
    }
    return testRequests
        .where(
          (row) =>
              row.patientName.toLowerCase().contains(query) ||
              row.patientId.toLowerCase().contains(query) ||
              row.mobile.toLowerCase().contains(query),
        )
        .toList();
  }

  List<DiagnosticsRequest> get reportFilteredResults {
    return globalResults.where((e) {
      final doctorMatch =
          doctorFilterController.text.isEmpty ||
          e.doctorName.toLowerCase().contains(
            doctorFilterController.text.toLowerCase(),
          );
      final patientMatch =
          patientFilterController.text.isEmpty ||
          e.patientName.toLowerCase().contains(
            patientFilterController.text.toLowerCase(),
          );
      final testMatch =
          testFilterController.text.isEmpty ||
          e.testRequested.toLowerCase().contains(
            testFilterController.text.toLowerCase(),
          );
      final paymentMatch =
          paymentStatus.value == 'Pending' || e.status == 'Completed';
      return doctorMatch && patientMatch && testMatch && paymentMatch;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    notesController.text = notes.value;
    Future<void>.delayed(const Duration(milliseconds: 700), () {
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    globalSearchController.dispose();
    patientSearchController.dispose();
    fromDateController.dispose();
    toDateController.dispose();
    doctorFilterController.dispose();
    patientFilterController.dispose();
    testFilterController.dispose();
    testCostController.dispose();
    notesController.dispose();
    super.onClose();
  }

  void notifyUi() {
    uiTick.value++;
  }

  void setMenu(int index) {
    selectedMenu.value = index;
  }

  void setDateQuickFilter(String value) {
    dateQuickFilter.value = value;
  }

  void setSelectedTestPerformed(String value) {
    selectedTestPerformed.value = value;
  }

  void setSampleCollected(bool value) {
    sampleCollected.value = value;
    selectedStatus.value = value ? 'Sample Collected' : 'Requested';
  }

  void setPaymentStatus(String value) {
    paymentStatus.value = value;
  }

  void setPaymentMethod(String value) {
    paymentMethod.value = value;
  }

  void selectPatient(DiagnosticsRequest patient) {
    selectedPatient.value = patient;
    selectedMenu.value = 3;
  }

  void saveProgress() {
    selectedStatus.value = sampleCollected.value
        ? 'Sample Collected'
        : 'Requested';
    Get.snackbar(
      'Saved',
      'Test entry progress saved.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void markCompleted() {
    selectedStatus.value = 'Completed';
    paymentStatus.value = 'Pending';
    Get.snackbar(
      'Completed',
      'Test marked as completed.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateRequestStatus(DiagnosticsRequest row, String status) {
    row.status = status;
    selectedPatient.value = row;
    notifyUi();
    Get.snackbar(
      'Status Updated',
      '${row.patientId} moved to $status.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void uploadMockReport() {
    uploadedReportName.value =
        'diagnostic_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
  }

  void generateInvoice() {
    final amount = testCostController.text.trim().isEmpty
        ? '0'
        : testCostController.text.trim();
    Get.defaultDialog(
      title: 'Invoice Generated',
      middleText:
          'Invoice created for amount ₹$amount with ${paymentMethod.value} (${paymentStatus.value}).',
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }
}
