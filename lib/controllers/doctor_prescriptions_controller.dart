import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/prescription_model.dart';

/// Controller for doctor prescriptions
class DoctorPrescriptionsController extends GetxController {
  final isLoading = false.obs;
  final prescriptions = <Prescription>[].obs;
  final previousPrescriptions = <Prescription>[].obs;

  // Form controllers
  final medicationController = TextEditingController();
  final dosageController = TextEditingController();
  final frequencyController = TextEditingController();
  final durationController = TextEditingController();
  final instructionsController = TextEditingController();
  final patientIdController = TextEditingController();

  final prescriptionFormKey = GlobalKey<FormState>();

  final frequencyOptions = ['Once Daily', 'Twice Daily', 'Thrice Daily', 'Every 4 hours', 'Every 6 hours', 'Every 8 hours'].obs;
  final selectedFrequency = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadPrescriptions();
  }

  /// Load prescriptions
  Future<void> loadPrescriptions() async {
    isLoading.value = true;

    try {
      // TODO: API call to fetch prescriptions
      prescriptions.value = [
        Prescription(
          id: '1',
          doctorId: '1',
          patientId: 'P1',
          medicationName: 'Amlodipine',
          dosage: '5mg',
          frequency: 'Once Daily',
          duration: 30,
          instructions: 'Take on empty stomach in morning',
          createdAt: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        ),
        Prescription(
          id: '2',
          doctorId: '1',
          patientId: 'P2',
          medicationName: 'Metformin',
          dosage: '500mg',
          frequency: 'Twice Daily',
          duration: 30,
          instructions: 'Take after meals',
          createdAt: DateTime.now(),
          expiryDate: DateTime.now().add(const Duration(days: 30)),
        ),
      ];

      previousPrescriptions.value = [
        Prescription(
          id: '3',
          doctorId: '1',
          patientId: 'P3',
          medicationName: 'Ibuprofen',
          dosage: '400mg',
          frequency: 'Thrice Daily',
          duration: 7,
          instructions: 'Take after meals for pain relief',
          createdAt: DateTime.now().subtract(const Duration(days: 60)),
          expiryDate: DateTime.now().subtract(const Duration(days: 30)),
        ),
      ];
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

  /// Validate medication name
  String? validateMedicationName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Medication name is required';
    }
    return null;
  }

  /// Validate dosage
  String? validateDosage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Dosage is required';
    }
    return null;
  }

  /// Validate duration
  String? validateDuration(String? value) {
    if (value == null || value.isEmpty) {
      return 'Duration is required';
    }
    if (int.tryParse(value) == null) {
      return 'Duration must be a number';
    }
    return null;
  }

  /// Validate instructions
  String? validateInstructions(String? value) {
    if (value == null || value.isEmpty) {
      return 'Instructions are required';
    }
    return null;
  }

  /// Save prescription
  Future<void> savePrescription() async {
    if (!prescriptionFormKey.currentState!.validate()) {
      return;
    }

    if (selectedFrequency.value == null) {
      Get.snackbar(
        'Validation Error',
        'Please select a frequency',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO: API call to save prescription
      final newPrescription = Prescription(
        id: DateTime.now().toString(),
        doctorId: '1',
        patientId: patientIdController.text,
        medicationName: medicationController.text,
        dosage: dosageController.text,
        frequency: selectedFrequency.value!,
        duration: int.parse(durationController.text),
        instructions: instructionsController.text,
        createdAt: DateTime.now(),
        expiryDate: DateTime.now().add(Duration(days: int.parse(durationController.text))),
      );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      prescriptions.add(newPrescription);

      Get.snackbar(
        'Success',
        'Prescription saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Clear form
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

  /// Update prescription
  Future<void> updatePrescription(String prescriptionId) async {
    // TODO: Implement update prescription
    Get.snackbar(
      'Success',
      'Prescription updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  /// Clear form
  void clearForm() {
    medicationController.clear();
    dosageController.clear();
    patientIdController.clear();
    durationController.clear();
    instructionsController.clear();
    selectedFrequency.value = null;
  }

  @override
  void onClose() {
    medicationController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
    patientIdController.dispose();
    super.onClose();
  }
}
