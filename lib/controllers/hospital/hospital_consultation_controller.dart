import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HospitalConsultationController extends GetxController {
  final isLoading = false.obs;

  final focusAreas = const [
    'Patient',
    'Consultant',
    'Specialisation',
    'Calender',
    'Payment',
  ];

  final selectedFocusArea = 'Patient'.obs;
  final isEmergencyAdmission = false.obs;

  final globalSearchController = TextEditingController();
  final patientAdmissionUnderDrController = TextEditingController();
  final admissionDepartmentController = TextEditingController();
  final paymentController = TextEditingController();

  final searchNameController = TextEditingController();
  final searchAgeController = TextEditingController();
  final searchGenderController = TextEditingController();
  final searchAddressController = TextEditingController();
  final searchHistoryController = TextEditingController();
  final searchLabsOrderedController = TextEditingController();
  final searchDateOfAdmissionController = TextEditingController();
  final searchDateOfDischargeController = TextEditingController();

  final dateOfAdmissionController = TextEditingController();
  final dateOfDischargeController = TextEditingController();
  final consultationsController = TextEditingController();
  final consultantsController = TextEditingController();
  final admittedUnderController = TextEditingController();

  final urgentGuideController = TextEditingController();
  final specialisationController = TextEditingController();
  final reasonForConsultationController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDefaults();
  }

  void _loadDefaults() {
    dateOfAdmissionController.text = 'May 01, 2026';
    dateOfDischargeController.text = 'May 05, 2026';
    consultationsController.text = 'General Medicine';
    consultantsController.text = 'Dr. Rajesh Kumar';
    admittedUnderController.text = 'City Medical Centre';

    searchDateOfAdmissionController.text = 'May 01, 2026';
    searchDateOfDischargeController.text = 'May 05, 2026';
  }

  void setFocusArea(String area) {
    selectedFocusArea.value = area;
  }

  void createNewConsultation() {
    clearConsultationForm();
    Get.snackbar(
      'New Consultation',
      'Consultation draft initialized.',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.toNamed('/hospital/consultation/form');
  }

  void saveConsultationDraft() {
    Get.snackbar(
      'Saved',
      'Consultation details saved successfully.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToModule(String route) {
    Get.toNamed(route);
  }

  void openConsultationHub() {
    Get.toNamed('/hospital/consultation');
  }

  void openIntakeScreen() {
    Get.toNamed('/hospital/consultation/intake');
  }

  void openSearchScreen() {
    Get.toNamed('/hospital/consultation/search');
  }

  void openAdmissionDetailsScreen() {
    Get.toNamed('/hospital/consultation/admission_details');
  }

  void openFormScreen() {
    Get.toNamed('/hospital/consultation/form');
  }

  void clearConsultationForm() {
    patientAdmissionUnderDrController.clear();
    admissionDepartmentController.clear();
    paymentController.clear();
    isEmergencyAdmission.value = false;

    globalSearchController.clear();
    searchNameController.clear();
    searchAgeController.clear();
    searchGenderController.clear();
    searchAddressController.clear();
    searchHistoryController.clear();
    searchLabsOrderedController.clear();

    urgentGuideController.clear();
    specialisationController.clear();
    reasonForConsultationController.clear();
    descriptionController.clear();

    _loadDefaults();
  }

  void submitConsultation() {
    saveConsultationDraft();
    Get.snackbar(
      'Submitted',
      'Consultation workflow submitted.',
      snackPosition: SnackPosition.BOTTOM,
    );
    Get.offNamed('/hospital/consultation');
  }

  @override
  void onClose() {
    globalSearchController.dispose();
    patientAdmissionUnderDrController.dispose();
    admissionDepartmentController.dispose();
    paymentController.dispose();

    searchNameController.dispose();
    searchAgeController.dispose();
    searchGenderController.dispose();
    searchAddressController.dispose();
    searchHistoryController.dispose();
    searchLabsOrderedController.dispose();
    searchDateOfAdmissionController.dispose();
    searchDateOfDischargeController.dispose();

    dateOfAdmissionController.dispose();
    dateOfDischargeController.dispose();
    consultationsController.dispose();
    consultantsController.dispose();
    admittedUnderController.dispose();

    urgentGuideController.dispose();
    specialisationController.dispose();
    reasonForConsultationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
