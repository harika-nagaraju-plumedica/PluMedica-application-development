import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/follow_up_model.dart';
import '../models/prescription_model.dart';
import '../models/referral_model.dart';
import '../services/admin_identity_service.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';

class DrugFormEntry {
  final TextEditingController drugNameController;
  final TextEditingController dosageController;
  final TextEditingController durationController;
  final TextEditingController instructionsController;
  final RxBool morning;
  final RxBool afternoon;
  final RxBool night;

  DrugFormEntry({
    String drugName = '',
    String dosage = '',
    String duration = '',
    String instructions = '',
    bool morning = true,
    bool afternoon = false,
    bool night = true,
  })  : drugNameController = TextEditingController(text: drugName),
        dosageController = TextEditingController(text: dosage),
        durationController = TextEditingController(text: duration),
        instructionsController = TextEditingController(text: instructions),
        morning = morning.obs,
        afternoon = afternoon.obs,
        night = night.obs;

  void dispose() {
    drugNameController.dispose();
    dosageController.dispose();
    durationController.dispose();
    instructionsController.dispose();
  }
}

class DoctorPrescriptionsController extends GetxController {
  final _clinicalDataService = Get.put(ClinicalDataService(), permanent: true);
  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
    ? Get.find<AdminIdentityService>()
    : Get.put(AdminIdentityService(), permanent: true);

  String get _currentDoctorId =>
    _adminIdentityService.getPrimaryId(AppRole.doctor);

  String get _currentDoctorName =>
    _adminIdentityService.getPrimaryName(AppRole.doctor);

  final isLoading = false.obs;
  final prescriptions = <Prescription>[].obs;
  final followUps = <FollowUpRecord>[].obs;
  final referrals = <DoctorReferral>[].obs;
  final drugForms = <DrugFormEntry>[].obs;

  final patientIdController = TextEditingController();
  final patientNameController = TextEditingController();
  final remarksController = TextEditingController();

  final prescriptionFormKey = GlobalKey<FormState>();

  final referralReasonController = TextEditingController();
  final referralDescriptionController = TextEditingController();
  final referralAttachmentController = TextEditingController();
  final selectedReferredDoctorId = Rx<String?>(null);

  final followUpNotesController = TextEditingController();
  final followUpUpdatedMedicationController = TextEditingController();
  final selectedFollowUpDate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      patientIdController.text = (args['patientId'] ?? '').toString();
      patientNameController.text = (args['patientName'] ?? '').toString();
    }
    addDrugEntry();
    loadPrescriptions();
  }

  Future<void> loadPrescriptions() async {
    isLoading.value = true;
    try {
      prescriptions.assignAll(_clinicalDataService.prescriptions);
      followUps.assignAll(_clinicalDataService.followUps);
      referrals.assignAll(_clinicalDataService.referrals);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load prescriptions: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get referralDoctorOptions {
    return _clinicalDataService.doctorDirectory
      .where((item) => item['id'] != _currentDoctorId)
        .toList();
  }

  void addDrugEntry() {
    drugForms.add(DrugFormEntry());
  }

  void removeDrugEntry(int index) {
    if (drugForms.length == 1) {
      Get.snackbar(
        'Validation Error',
        'At least one drug entry is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    final entry = drugForms[index];
    entry.dispose();
    drugForms.removeAt(index);
  }

  bool _isDrugEntryValid(DrugFormEntry entry) {
    if (entry.drugNameController.text.trim().isEmpty) return false;
    if (entry.dosageController.text.trim().isEmpty) return false;
    if (entry.instructionsController.text.trim().isEmpty) return false;
    final duration = int.tryParse(entry.durationController.text.trim());
    if (duration == null || duration <= 0) return false;
    return entry.morning.value || entry.afternoon.value || entry.night.value;
  }

  List<DrugEntry> _buildDrugEntries() {
    return drugForms
        .map(
          (entry) => DrugEntry(
            drugName: entry.drugNameController.text.trim(),
            dosage: entry.dosageController.text.trim(),
            durationDays: int.parse(entry.durationController.text.trim()),
            morning: entry.morning.value,
            afternoon: entry.afternoon.value,
            night: entry.night.value,
            instructions: entry.instructionsController.text.trim(),
          ),
        )
        .toList();
  }

  Future<void> savePrescription() async {
    if (!prescriptionFormKey.currentState!.validate()) {
      return;
    }

    if (patientNameController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Patient name is required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (drugForms.any((entry) => !_isDrugEntryValid(entry))) {
      Get.snackbar(
        'Validation Error',
        'Please complete all drug fields and select at least one timing.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      final drugEntries = _buildDrugEntries();
      final maxDuration = drugEntries
          .map((entry) => entry.durationDays)
          .fold<int>(0, (prev, item) => item > prev ? item : prev);

      final newPrescription = Prescription(
        id: 'RX-${DateTime.now().millisecondsSinceEpoch}',
        doctorId: _currentDoctorId,
        doctorName: _currentDoctorName,
        patientId: patientIdController.text.trim(),
        patientName: patientNameController.text.trim(),
        drugEntries: drugEntries,
        remarks: remarksController.text.trim(),
        createdAt: DateTime.now(),
        expiryDate: DateTime.now().add(Duration(days: maxDuration)),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      _clinicalDataService.addPrescription(newPrescription);
      prescriptions.assignAll(_clinicalDataService.prescriptions);

      Get.snackbar(
        'Success',
        'Prescription saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      clearForm();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save prescription: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitReferral({
    required String patientId,
    required String patientName,
  }) async {
    final selectedDoctorId = selectedReferredDoctorId.value;
    if (patientId.trim().isEmpty ||
        patientName.trim().isEmpty ||
        selectedDoctorId == null ||
        selectedDoctorId.trim().isEmpty ||
        referralReasonController.text.trim().isEmpty ||
        referralDescriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Patient ID, patient name, doctor ID, reason and description are required',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final targetDoctor = referralDoctorOptions.firstWhereOrNull(
      (doc) => doc['id'] == selectedDoctorId,
    );
    if (targetDoctor == null) {
      Get.snackbar('Error', 'Selected doctor not found');
      return;
    }

    final referral = DoctorReferral(
      id: 'REF-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      patientName: patientName,
      referredDoctorId: selectedDoctorId,
      referredDoctorName: targetDoctor['name'] as String,
      referringDoctorId: _currentDoctorId,
      referringDoctorName: _currentDoctorName,
      reason: referralReasonController.text.trim(),
      description: referralDescriptionController.text.trim(),
      attachmentName: referralAttachmentController.text.trim().isEmpty
          ? null
          : referralAttachmentController.text.trim(),
      createdAt: DateTime.now(),
    );

    _clinicalDataService.addReferral(referral);
    referrals.assignAll(_clinicalDataService.referrals);
    referralReasonController.clear();
    referralDescriptionController.clear();
    referralAttachmentController.clear();
    selectedReferredDoctorId.value = null;
    Get.back();
    Get.snackbar('Success', 'Referral submitted');
  }

  Future<void> addFollowUp({required Prescription prescription}) async {
    if (followUpNotesController.text.trim().isEmpty ||
        selectedFollowUpDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please add notes and next visit date',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final followUp = FollowUpRecord(
      id: 'FU-${DateTime.now().millisecondsSinceEpoch}',
      prescriptionId: prescription.id,
      patientId: prescription.patientId,
      patientName: prescription.patientName,
      doctorId: prescription.doctorId,
      doctorName: prescription.doctorName,
      notes: followUpNotesController.text.trim(),
      updatedMedication: followUpUpdatedMedicationController.text.trim().isEmpty
          ? null
          : followUpUpdatedMedicationController.text.trim(),
      nextVisitDate: selectedFollowUpDate.value!,
      createdAt: DateTime.now(),
    );

    _clinicalDataService.addFollowUp(followUp);
    followUps.assignAll(_clinicalDataService.followUps);
    followUpNotesController.clear();
    followUpUpdatedMedicationController.clear();
    selectedFollowUpDate.value = null;
    Get.back();
    Get.snackbar('Success', 'Follow-up added');
  }

  void clearForm() {
    patientIdController.clear();
    patientNameController.clear();
    remarksController.clear();
    for (final entry in drugForms) {
      entry.dispose();
    }
    drugForms.clear();
    addDrugEntry();
  }

  @override
  void onClose() {
    for (final entry in drugForms) {
      entry.dispose();
    }
    patientIdController.dispose();
    patientNameController.dispose();
    remarksController.dispose();
    referralReasonController.dispose();
    referralDescriptionController.dispose();
    referralAttachmentController.dispose();
    followUpNotesController.dispose();
    followUpUpdatedMedicationController.dispose();
    super.onClose();
  }
}
