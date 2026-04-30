import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/diagnostics/diagnostics_models.dart';
import '../../utils/file_pick_utils.dart';
import '../../services/patient_session_service.dart';

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
  final globalPatientSearchController = TextEditingController();
  final testRequestSearchController = TextEditingController();
  final reportsSearchController = TextEditingController();
  final paymentSearchController = TextEditingController();
  final paymentFromDateController = TextEditingController();
  final paymentToDateController = TextEditingController();
  final patientDetailsDateFilter = 'Day'.obs;
  final testRequestSourceFilter = 'All'.obs;

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
      doctorName: 'Sunrise Pharmacy',
      source: 'Pharmacy',
      testRequested: 'Thyroid Panel',
      status: 'In Progress',
      mobile: '9799999999',
      date: '28 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Neha Gupta',
      patientId: 'PAT-0004',
      doctorName: 'Self',
      source: 'Patient',
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
      event: 'New request received from Plumedica Hospital and Patient portal',
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

  final flowPatients = <DiagnosticsRequest>[
    DiagnosticsRequest(
      patientName: 'Pt-1',
      patientId: 'ID-1001',
      doctorName: 'Dr. Arun',
      source: 'Doctor',
      testRequested: 'CBC',
      status: 'Sample Collected',
      mobile: '9000000001',
      date: '30 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Pt-2',
      patientId: 'ID-1002',
      doctorName: 'MediPlus Pharmacy',
      source: 'Pharmacy',
      testRequested: 'Lipid Profile',
      status: 'In Progress',
      mobile: '9000000002',
      date: '30 Apr 2026',
    ),
    DiagnosticsRequest(
      patientName: 'Pt-3',
      patientId: 'ID-1003',
      doctorName: 'Self',
      source: 'Patient',
      testRequested: 'Thyroid Panel',
      status: 'Completed',
      mobile: '9000000003',
      date: '29 Apr 2026',
    ),
  ].obs;

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

  List<DiagnosticsRequest> get globalPatientResults {
    return _filterByIdNo(globalPatientSearchController.text);
  }

  List<DiagnosticsRequest> get testRequestResults {
    final byId = _filterByIdNo(testRequestSearchController.text);
    if (testRequestSourceFilter.value == 'All') {
      return byId;
    }
    return byId
        .where((patient) => patient.source == testRequestSourceFilter.value)
        .toList();
  }

  List<DiagnosticsRequest> get reportsResults {
    return _filterByIdNo(reportsSearchController.text);
  }

  List<DiagnosticsRequest> get paymentResults {
    final query = paymentSearchController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return flowPatients;
    }
    return flowPatients
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
    globalPatientSearchController.dispose();
    testRequestSearchController.dispose();
    reportsSearchController.dispose();
    paymentSearchController.dispose();
    paymentFromDateController.dispose();
    paymentToDateController.dispose();
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

  void setPatientDetailsDateFilter(String value) {
    patientDetailsDateFilter.value = value;
  }

  void setTestRequestSourceFilter(String value) {
    testRequestSourceFilter.value = value;
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

  void selectFlowPatient(DiagnosticsRequest patient) {
    selectedPatient.value = patient;
  }

  List<DiagnosticsRequest> _filterByIdNo(String rawQuery) {
    final query = rawQuery.toLowerCase().trim();
    if (query.isEmpty) {
      return flowPatients;
    }
    return flowPatients
        .where(
          (patient) =>
              patient.patientId.toLowerCase().contains(query) ||
              patient.patientName.toLowerCase().contains(query),
        )
        .toList();
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

  Future<void> uploadMockReport() async {
    final fileName = await FilePickUtils.pickSingleFileName(
      dialogTitle: 'Select Diagnostic Report',
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (fileName == null) {
      Get.snackbar(
        'Upload Cancelled',
        'No file selected.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    uploadedReportName.value = fileName;
    Get.snackbar(
      'Report Selected',
      '$fileName selected for upload.',
      snackPosition: SnackPosition.BOTTOM,
    );
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

  Future<void> logout() async {
    await PatientSessionService.logoutRole(AppRole.diagnostics);
    Get.offAllNamed('/role_selection');
  }
}
