import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import '../services/admin_identity_service.dart';
import '../services/api_exception.dart';
import '../services/clinical_data_service.dart';
import '../services/patient_session_service.dart';
import '../services/registration_service.dart';
import '../utils/file_pick_utils.dart';

/// Controller for doctor registration flow
class DoctorRegistrationController extends GetxController {
  final _registrationService = RegistrationService();
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

  // Form controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final qualificationController = TextEditingController();
  final specializationController = TextEditingController();
  final graduationYearController = TextEditingController();
  final experienceController = TextEditingController();
  final clinicAddressController = TextEditingController();
  final licenseNumberController = TextEditingController();

  // Observable state
  final isLoading = false.obs;
  final registrationFormKey = GlobalKey<FormState>();
  final selectedAvailability = <String>[].obs;
  final selectedDayTimeSlots = <String, String>{}.obs;
  final selectedDaySlotStatus = <String, String>{}.obs;
  final daySlotStatuses = <String, List<Map<String, String>>>{}.obs;
  final selectedDayConsultationModes = <String, String>{}.obs;
  final expandedAvailabilityDay = Rx<String?>(null);
  final selectedArea = 'North Zone'.obs;
  final isAvailabilityActive = true.obs;
  final daySectionKeys = <String, GlobalKey>{};
  final medicalLicenseFileName = Rx<String?>(null); // Renamed from resumeFileName
  final medicalLicenseFile = Rx<PlatformFile?>(null);
  final registrationStatus = Rx<String>('Pending Approval');

  final List<String> qualificationsList = [
    'MBBS',
    'MD',
    'MS',
    'BDS',
    'BAMS',
    'BHMS',
  ];

  final List<String> specializationsList = [
    'General Medicine',
    'Cardiology',
    'Neurology',
    'Orthopedics',
    'Pediatrics',
    'Dermatology',
    'Psychiatry',
    'Ophthalmology',
    'ENT',
    'Dentistry',
  ];

  final List<String> areaList = [
    'North Zone',
    'Central Zone',
    'South Zone',
    'East Zone',
    'West Zone',
  ];

  final Map<String, List<String>> specializationByArea = {
    'North Zone': ['General Medicine', 'Pediatrics', 'Orthopedics'],
    'Central Zone': ['Cardiology', 'Neurology', 'ENT'],
    'South Zone': ['Dermatology', 'Psychiatry', 'Dentistry'],
    'East Zone': ['General Medicine', 'Ophthalmology', 'Pediatrics'],
    'West Zone': ['Cardiology', 'Orthopedics', 'Dermatology'],
  };

  final List<String> daysList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  final List<String> timeSlotsList = [
    '09:00 AM - 01:00 PM',
    '02:00 PM - 06:00 PM',
    '06:00 PM - 09:00 PM',
  ];

  final List<String> consultationModesList = [
    'Virtual',
    'In-Person',
    'Home Service',
  ];

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.doctor);
    if (isRegistered) {
      Get.offAllNamed('/doctor_login');
    }
  }

  /// Toggle availability day
  void toggleAvailabilityDay(String day) {
    if (selectedAvailability.contains(day)) {
      selectedAvailability.remove(day);
      selectedDayTimeSlots.remove(day);
      selectedDayConsultationModes.remove(day);
    } else {
      selectedAvailability.add(day);
    }
  }

  /// Check if day is selected
  bool isAvailabilitySelected(String day) {
    return selectedAvailability.contains(day);
  }

  /// Update selected time slot for a given day
  void setDayTimeSlot(String day, String slot) {
    if (!selectedAvailability.contains(day)) {
      selectedAvailability.add(day);
    }
    selectedDayTimeSlots[day] = slot;
    final slots = List<Map<String, String>>.from(daySlotStatuses[day] ?? []);
    if (!slots.any((item) => item['slot'] == slot)) {
      slots.add({'slot': slot, 'status': 'Free'});
      daySlotStatuses[day] = slots;
    }
  }

  void addDaySlot({
    required String day,
    required String slot,
    required String status,
  }) {
    if (!selectedAvailability.contains(day)) {
      selectedAvailability.add(day);
    }
    final slots = List<Map<String, String>>.from(daySlotStatuses[day] ?? []);
    if (slots.any((item) => item['slot'] == slot)) {
      return;
    }
    slots.add({'slot': slot, 'status': status});
    daySlotStatuses[day] = slots;
  }

  void removeDaySlot({required String day, required int index}) {
    final slots = List<Map<String, String>>.from(daySlotStatuses[day] ?? []);
    if (index < 0 || index >= slots.length) {
      return;
    }
    slots.removeAt(index);
    daySlotStatuses[day] = slots;
  }

  /// Update selected consultation mode for a given day
  void setDayConsultationMode(String day, String mode) {
    if (!selectedAvailability.contains(day)) {
      selectedAvailability.add(day);
    }
    selectedDayConsultationModes[day] = mode;
  }

  /// Open one day panel at a time for compact availability editing
  void toggleAvailabilityPanel(String day) {
    if (expandedAvailabilityDay.value == day) {
      expandedAvailabilityDay.value = null;
      return;
    }

    expandedAvailabilityDay.value = day;
    if (!selectedAvailability.contains(day)) {
      selectedAvailability.add(day);
    }
  }

  /// Remove a day from availability and clear its configured data
  void removeAvailabilityDay(String day) {
    selectedAvailability.remove(day);
    selectedDayTimeSlots.remove(day);
    selectedDaySlotStatus.remove(day);
    daySlotStatuses.remove(day);
    selectedDayConsultationModes.remove(day);
    if (expandedAvailabilityDay.value == day) {
      expandedAvailabilityDay.value = null;
    }
  }

  /// Whether a day already has complete availability data configured
  bool hasConfiguredAvailability(String day) {
    return selectedAvailability.contains(day) &&
        ((daySlotStatuses[day]?.isNotEmpty ?? false) ||
            (selectedDayTimeSlots[day]?.isNotEmpty ?? false)) &&
      (selectedDayConsultationModes[day]?.isNotEmpty ?? false);
  }

  /// Stable key for each day card so UI can scroll it into view when expanded
  GlobalKey getDaySectionKey(String day) {
    return daySectionKeys.putIfAbsent(day, () => GlobalKey());
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    const emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(emailPattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  /// Validate confirm password
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate mobile number
  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Mobile number must be 10 digits';
    }
    if (!value.contains(RegExp(r'^[0-9]{10}$'))) {
      return 'Mobile number should only contain digits';
    }
    return null;
  }

  /// Validate license number
  String? validateLicense(String? value) {
    if (value == null || value.isEmpty) {
      return 'Medical License Number is required';
    }
    if (value.length < 5) {
      return 'Medical License Number is invalid';
    }
    return null;
  }

  /// Validate graduation year
  String? validateGraduationYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Year of Graduation is required';
    }
    final year = int.tryParse(value);
    if (year == null) {
      return 'Enter a valid year';
    }
    final currentYear = DateTime.now().year;
    if (year < 1950 || year > currentYear) {
      return 'Enter a year between 1950 and $currentYear';
    }
    return null;
  }

  /// Validate years of experience against graduation year
  String? validateExperience(String? value) {
    if (value == null || value.isEmpty) {
      return 'Experience is required';
    }

    final experience = int.tryParse(value);
    if (experience == null || experience < 0) {
      return 'Enter a valid number';
    }

    final graduationYear = int.tryParse(graduationYearController.text);
    if (graduationYear != null) {
      final maxPossibleExperience = DateTime.now().year - graduationYear;
      if (experience > maxPossibleExperience) {
        return 'Experience cannot exceed $maxPossibleExperience years based on graduation year';
      }
    }

    return null;
  }

  /// Upload Medical License
  Future<void> uploadMedicalLicense() async {
    final file = await FilePickUtils.pickSingleFile(
      dialogTitle: 'Select Medical License',
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (file == null) {
      Get.snackbar(
        'Upload Cancelled',
        'No file selected.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    medicalLicenseFile.value = file;
    medicalLicenseFileName.value = file.name;

    Get.snackbar(
      'Document Selected',
      '${file.name} selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Submit registration
  Future<void> submitRegistration() async {
    if (!registrationFormKey.currentState!.validate()) {
      return;
    }

    if (selectedAvailability.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select at least one availability day',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isAvailabilityActive.value) {
      selectedAvailability.clear();
      daySlotStatuses.clear();
      selectedDayTimeSlots.clear();
      selectedDayConsultationModes.clear();
    }

    for (final day in selectedAvailability) {
      final selectedSlot = selectedDayTimeSlots[day];
      final daySlots = daySlotStatuses[day] ?? const [];
      final selectedMode = selectedDayConsultationModes[day];
      if ((selectedSlot == null || selectedSlot.isEmpty) && daySlots.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please add at least one slot for $day',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
      if (selectedMode == null || selectedMode.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select consultation mode for $day',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

    }

    isLoading.value = true;

    try {
      final availabilityPayload = <Map<String, dynamic>>[];
      for (final day in selectedAvailability) {
        final consultationMode = selectedDayConsultationModes[day] ?? 'Virtual';
        final slots = List<Map<String, String>>.from(daySlotStatuses[day] ?? const []);
        for (final slot in slots) {
          availabilityPayload.add({
            'day': day,
            'timeSlot': slot['slot'] ?? '',
            'slotStatus': slot['status'] ?? 'Free',
            'consultationMode': consultationMode,
          });
        }
      }

      final response = await _registrationService.registerDoctor(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        mobileNumber: mobileController.text.trim(),
        password: passwordController.text,
        qualification: qualificationController.text.trim(),
        specialization: specializationController.text.trim(),
        yearOfGraduation: graduationYearController.text.trim(),
        yearsOfExperience: experienceController.text.trim(),
        clinicAddress: clinicAddressController.text.trim(),
        medicalLicenseNumber: licenseNumberController.text.trim(),
        availabilitySlots: availabilityPayload,
        medicalLicenseDocument: medicalLicenseFile.value,
      );

      final weeklySlots = <String, List<Map<String, String>>>{};
      for (final day in selectedAvailability) {
        final slots = List<Map<String, String>>.from(daySlotStatuses[day] ?? const []);
        if (slots.isNotEmpty) {
          weeklySlots[day] = slots;
        }
      }

      _clinicalDataService.upsertDoctorDirectory({
        'id': _currentDoctorId,
        'name': fullNameController.text.trim().isEmpty
            ? _currentDoctorName
            : fullNameController.text.trim(),
        'specialization': specializationController.text.trim().isEmpty
            ? 'General Medicine'
            : specializationController.text.trim(),
        'area': selectedArea.value,
        'isActive': isAvailabilityActive.value,
        'availabilitySlots': weeklySlots,
      });

      await PatientSessionService.markRoleRegistered(
        AppRole.doctor,
        email: emailController.text,
        displayName: fullNameController.text.trim(),
        isApproved: false,
      );

      registrationStatus.value = 'Pending Approval';

      Get.snackbar(
        'Registration Submitted',
        response.message.isEmpty
            ? 'Your registration is pending super admin approval.'
            : response.message,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(
        '/pending-verification',
        arguments: {
          'registrationType': 'Doctor',
          'userEmail': emailController.text.trim(),
        },
      );
    } on ApiException catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit registration: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    qualificationController.dispose();
    specializationController.dispose();
    graduationYearController.dispose();
    experienceController.dispose();
    clinicAddressController.dispose();
    licenseNumberController.dispose();
    super.onClose();
  }
}
