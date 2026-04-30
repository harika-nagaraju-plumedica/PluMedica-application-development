import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/referral_model.dart';
import '../services/admin_identity_service.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';

class DoctorReferralFlowController extends GetxController {
  final _clinicalDataService = Get.isRegistered<ClinicalDataService>()
      ? Get.find<ClinicalDataService>()
      : Get.put(ClinicalDataService(), permanent: true);

  final _adminIdentityService = Get.isRegistered<AdminIdentityService>()
      ? Get.find<AdminIdentityService>()
      : Get.put(AdminIdentityService(), permanent: true);

  String get _currentDoctorId =>
      _adminIdentityService.getPrimaryId(AppRole.doctor);

  String get _currentDoctorName =>
      _adminIdentityService.getPrimaryName(AppRole.doctor);

  final patientIdController = TextEditingController();
  final patientNameController = TextEditingController();
  final reasonForRefController = TextEditingController();
  final descriptionController = TextEditingController();
  final doctorIdController = TextEditingController();
  final doctorNameController = TextEditingController();
  final doctorExperienceController = TextEditingController();
  final consultationFeeController = TextEditingController();

  final selectedPatientName = ''.obs;
  final selectedSpecialisation = RxnString();
  final selectedVisitType = 'OP Consultation'.obs;
  final selectedAvailabilityDate = Rxn<DateTime>();
  final selectedDoctorId = RxnString();
  final selectedTimeSlot = RxnString();
  final hasSearchedDoctors = false.obs;

  static const visitTypeOptions = <String>[
    'OP Consultation',
    'Video Consultation',
    'Emergency',
    'Follow-up',
  ];

  List<Map<String, String>> get patientDirectory {
    final index = <String, String>{};

    for (final appointment in _clinicalDataService.appointments) {
      index[appointment.patientId] = appointment.patientName;
    }
    for (final prescription in _clinicalDataService.prescriptions) {
      index[prescription.patientId] = prescription.patientName;
    }
    for (final referral in _clinicalDataService.referrals) {
      index[referral.patientId] = referral.patientName;
    }

    if (!index.containsKey('P1')) {
      index['P1'] = 'Rajesh Kumar';
    }

    return index.entries
        .map((entry) => {'id': entry.key, 'name': entry.value})
        .toList()
      ..sort((a, b) => a['id']!.compareTo(b['id']!));
  }

  List<Map<String, dynamic>> get doctorDirectory {
    return _clinicalDataService.doctorDirectory.map((doctor) {
      final id = (doctor['id'] ?? '').toString();
      final freeSlots = _freeSlotsForDoctor(id);
      return {
        ...doctor,
        'fee': _feeForDoctorId(id),
        'rating': _ratingForDoctorId(id),
        'reviews': _reviewsForDoctorId(id),
        'experience': _experienceForDoctorId(id),
        'visitTypes': visitTypeOptions,
        'freeSlots': freeSlots,
      };
    }).toList();
  }

  List<String> get specialisationOptions {
    final options = doctorDirectory
        .map((doctor) => (doctor['specialization'] ?? '').toString())
        .where((specialisation) => specialisation.isNotEmpty)
        .toSet()
        .toList();
    options.sort();
    return options;
  }

  List<Map<String, dynamic>> get filteredDoctors {
    return doctorDirectory.where((doctor) {
      final feeQuery = consultationFeeController.text.trim();
      final specialisation = (doctor['specialization'] ?? '').toString();
      final fee = (doctor['fee'] ?? 0) as int;

      final specialisationMatch = selectedSpecialisation.value == null ||
          selectedSpecialisation.value == specialisation;
      final visitTypeMatch =
          (doctor['visitTypes'] as List<String>).contains(selectedVisitType.value);

      final feeMatch = feeQuery.isEmpty ||
          (int.tryParse(feeQuery) != null && fee <= int.parse(feeQuery));

      final slotsForCurrentFilter = slotsForDoctor((doctor['id'] ?? '').toString());
      final availabilityMatch = slotsForCurrentFilter.isNotEmpty;

      return specialisationMatch &&
          visitTypeMatch &&
          feeMatch &&
          availabilityMatch;
    }).toList();
  }

  List<Map<String, String>> get patientSearchResults {
    final query = patientIdController.text.toLowerCase().trim();
    if (query.isEmpty) {
      return patientDirectory;
    }

    return patientDirectory
        .where(
          (patient) =>
              patient['id']!.toLowerCase().contains(query) ||
              patient['name']!.toLowerCase().contains(query),
        )
        .toList();
  }

  List<String> get availableTimeSlots {
    final doctorId = selectedDoctorId.value;
    if (doctorId == null) {
      return const [];
    }
    return slotsForDoctor(doctorId);
  }

  List<String> slotsForDoctor(String doctorId) {
    final selectedDate = selectedAvailabilityDate.value;
    if (selectedDate == null) {
      return _freeSlotsForDoctor(doctorId);
    }
    final daySlots = _daySpecificFreeSlots(doctorId, selectedDate);
    if (daySlots.isNotEmpty) {
      return daySlots;
    }
    // Fallback to any known free slot so doctors are still discoverable.
    return _freeSlotsForDoctor(doctorId);
  }

  Map<String, dynamic>? get selectedDoctorData {
    final doctorId = selectedDoctorId.value;
    if (doctorId == null) {
      return null;
    }
    return doctorDirectory.firstWhereOrNull((doctor) => doctor['id'] == doctorId);
  }

  bool get hasDoctorFilterInput {
    return consultationFeeController.text.trim().isNotEmpty ||
        selectedSpecialisation.value != null ||
        selectedAvailabilityDate.value != null ||
        selectedVisitType.value != visitTypeOptions.first;
  }

  void autofillDoctorDetailsFromId(String value) {
    final query = value.trim().toLowerCase();
    if (query.isEmpty) {
      return;
    }

    final matchedDoctor = doctorDirectory.firstWhereOrNull(
      (doctor) => ((doctor['id'] ?? '').toString().toLowerCase() == query),
    );

    if (matchedDoctor == null) {
      return;
    }

    final doctorId = (matchedDoctor['id'] ?? '').toString();
    selectedDoctorId.value = doctorId;

    final doctorName = (matchedDoctor['name'] ?? '').toString();
    if (doctorName.isNotEmpty) {
      doctorNameController.text = doctorName;
    }

    final specialization = (matchedDoctor['specialization'] ?? '').toString();
    if (specialization.isNotEmpty) {
      selectedSpecialisation.value = specialization;
    }

    doctorExperienceController.text =
        '${matchedDoctor['experience'] ?? _experienceForDoctorId(doctorId)}';

    final fee = matchedDoctor['fee'];
    if (fee != null) {
      consultationFeeController.text = fee.toString();
    }

    final slots = availableTimeSlots;
    selectedTimeSlot.value = slots.isNotEmpty ? slots.first : null;
  }

  void selectDoctorFromSuggestion(Map<String, dynamic> doctor) {
    final doctorId = (doctor['id'] ?? '').toString();
    if (doctorId.isEmpty) {
      return;
    }

    doctorIdController.text = doctorId;
    selectedDoctorId.value = doctorId;
    autofillDoctorDetailsFromId(doctorId);
    update();
  }

  bool validateReferralForm() {
    final patientId = patientIdController.text.trim();
    final patientName = patientNameController.text.trim();

    if (patientId.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Patient ID is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (patientName.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Patient Name is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedSpecialisation.value == null) {
      Get.snackbar(
        'Validation Error',
        'Select specialization.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (reasonForRefController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Reason for Ref is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Description is required.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  bool validateDoctorSelection() {
    if (selectedDoctorId.value == null) {
      Get.snackbar(
        'Validation Error',
        'Select a doctor.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedTimeSlot.value == null) {
      Get.snackbar(
        'Validation Error',
        'Select Time Slot.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (selectedAvailabilityDate.value == null) {
      Get.snackbar(
        'Validation Error',
        'Select Availability Date.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void selectPatient(String patientId) {
    patientIdController.text = patientId;
    final patient = patientDirectory.firstWhereOrNull((p) => p['id'] == patientId);
    selectedPatientName.value = patient?['name'] ?? '';
    patientNameController.text = selectedPatientName.value;
    update();
  }

  void onPatientIdChanged(String value) {
    final patientId = value.trim();
    final patient = patientDirectory.firstWhereOrNull((p) => p['id'] == patientId);
    if (patient != null) {
      selectedPatientName.value = patient['name'] ?? '';
      patientNameController.text = selectedPatientName.value;
    }
  }

  void onPatientNameChanged(String value) {
    final query = value.trim().toLowerCase();
    selectedPatientName.value = value.trim();
    if (query.isEmpty) {
      return;
    }

    final patient = patientDirectory.firstWhereOrNull(
      (p) => (p['name'] ?? '').toLowerCase() == query,
    );
    if (patient != null) {
      patientIdController.text = patient['id'] ?? '';
    }
  }

  void onDoctorFilterChanged() {
    _autofillFirstAvailableDoctor();
    update();
  }

  void _autofillFirstAvailableDoctor() {
    final matches = filteredDoctors;
    if (matches.isEmpty) {
      return;
    }

    final selectedId = selectedDoctorId.value;
    final selectedStillValid = selectedId != null &&
        matches.any((doctor) => (doctor['id'] ?? '').toString() == selectedId);

    if (selectedStillValid) {
      return;
    }

    selectDoctorFromSuggestion(matches.first);
  }

  void submitReferralForm() {
    if (!validateReferralForm()) {
      return;
    }
    _autofillFirstAvailableDoctor();
    Get.toNamed('/doctor/referrals/search');
  }

  void submitReferral() {
    if (!validateReferralForm()) {
      return;
    }
    if (!validateDoctorSelection()) {
      Get.snackbar(
        'Select Doctor',
        'Search available doctors and select a time slot first.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    confirmReferral();
  }

  void searchDoctors() {
    hasSearchedDoctors.value = true;
    if (filteredDoctors.isEmpty) {
      Get.snackbar(
        'No Results',
        'No doctors match the current filters.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.toNamed('/doctor/referrals/list');
  }

  void proceedToConfirmation() {
    if (!validateDoctorSelection()) {
      return;
    }
    Get.toNamed('/doctor/referrals/confirmation');
  }

  void confirmReferral() {
    final doctor = selectedDoctorData;
    if (doctor == null) {
      Get.snackbar('Error', 'Selected doctor not found.');
      return;
    }

    final patientId = patientIdController.text.trim();
    final resolvedPatientName = patientNameController.text.trim().isNotEmpty
      ? patientNameController.text.trim()
      : (selectedPatientName.value.isNotEmpty
          ? selectedPatientName.value
          : (patientDirectory
              .firstWhereOrNull((item) => item['id'] == patientId)?['name'] ??
            'Unknown Patient'));

    final referral = DoctorReferral(
      id: 'REF-${DateTime.now().millisecondsSinceEpoch}',
      patientId: patientId,
      patientName: resolvedPatientName,
      referredDoctorId: (doctor['id'] ?? '').toString(),
      referredDoctorName: doctorNameController.text.trim().isNotEmpty
          ? doctorNameController.text.trim()
          : (doctor['name'] ?? '').toString(),
      referringDoctorId: _currentDoctorId,
      referringDoctorName: _currentDoctorName,
      reason: reasonForRefController.text.trim(),
      description: descriptionController.text.trim(),
      visitType: selectedVisitType.value,
      requestedDate: selectedAvailabilityDate.value,
      requestedTimeSlot: selectedTimeSlot.value,
        consultationFee: int.tryParse(consultationFeeController.text.trim()) ??
          (doctor['fee'] as int?),
        doctorSpecialization: selectedSpecialisation.value ??
          (doctor['specialization'] ?? '').toString(),
      hospitalOrClinic: 'Plumedica Clinic',
      createdAt: DateTime.now(),
      status: 'Pending',
    );

    _clinicalDataService.createReferralRequest(referral);

    Get.snackbar(
      'Referral Sent',
      'Referral request sent to ${referral.referredDoctorName}.',
      snackPosition: SnackPosition.BOTTOM,
    );

    _resetFlow();
    Get.offAllNamed('/doctor_dashboard');
  }

  Future<void> pickAvailabilityDate(BuildContext context) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      initialDate: selectedAvailabilityDate.value ?? now,
    );
    if (date != null) {
      selectedAvailabilityDate.value = date;
      _autofillFirstAvailableDoctor();
      update();
    }
  }

  int _feeForDoctorId(String doctorId) {
    return switch (doctorId) {
      'DOC001' => 500,
      'DOC002' => 800,
      'DOC003' => 650,
      _ => 600,
    };
  }

  double _ratingForDoctorId(String doctorId) {
    return switch (doctorId) {
      'DOC001' => 4.7,
      'DOC002' => 4.9,
      'DOC003' => 4.5,
      _ => 4.4,
    };
  }

  int _reviewsForDoctorId(String doctorId) {
    return switch (doctorId) {
      'DOC001' => 120,
      'DOC002' => 184,
      'DOC003' => 96,
      _ => 75,
    };
  }

  int _experienceForDoctorId(String doctorId) {
    return switch (doctorId) {
      'DOC001' => 10,
      'DOC002' => 14,
      'DOC003' => 8,
      _ => 7,
    };
  }

  List<String> _freeSlotsForDoctor(String doctorId) {
    final doctor = _clinicalDataService.doctorDirectory
        .firstWhereOrNull((item) => item['id'] == doctorId);
    if (doctor == null) {
      return const [];
    }

    final availability = Map<String, dynamic>.from(
      doctor['availabilitySlots'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

    final slots = <String>[];
    for (final daySlots in availability.values) {
      final list = List<Map<String, dynamic>>.from(daySlots as List? ?? const []);
      for (final slot in list) {
        if ((slot['status'] ?? 'Free') == 'Free') {
          slots.add((slot['label'] ?? '').toString());
        }
      }
    }
    return slots.toSet().toList();
  }

  List<String> _daySpecificFreeSlots(String doctorId, DateTime date) {
    final day = _weekdayName(date);
    return _clinicalDataService.getFreeDoctorSlotsForDay(
      doctorId: doctorId,
      day: day,
    );
  }

  String _weekdayName(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[date.weekday - 1];
  }

  void _resetFlow() {
    patientIdController.clear();
    patientNameController.clear();
    reasonForRefController.clear();
    descriptionController.clear();
    doctorIdController.clear();
    doctorNameController.clear();
    doctorExperienceController.clear();
    consultationFeeController.clear();
    selectedPatientName.value = '';
    selectedSpecialisation.value = null;
    selectedVisitType.value = 'OP Consultation';
    selectedAvailabilityDate.value = null;
    selectedDoctorId.value = null;
    selectedTimeSlot.value = null;
    hasSearchedDoctors.value = false;
  }

  @override
  void onClose() {
    patientIdController.dispose();
    patientNameController.dispose();
    reasonForRefController.dispose();
    descriptionController.dispose();
    doctorIdController.dispose();
    doctorNameController.dispose();
    doctorExperienceController.dispose();
    consultationFeeController.dispose();
    super.onClose();
  }
}
