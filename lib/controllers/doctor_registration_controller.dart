import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for doctor registration flow
class DoctorRegistrationController extends GetxController {
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
  final selectedDayConsultationModes = <String, String>{}.obs;
  final offersHomeTreatment = false.obs;
  final medicalLicenseFileName = Rx<String?>(null); // Renamed from resumeFileName
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
  ];

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
    selectedDayTimeSlots[day] = slot;
  }

  /// Update selected consultation mode for a given day
  void setDayConsultationMode(String day, String mode) {
    selectedDayConsultationModes[day] = mode;
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
    // TODO: Implement actual file picker
    // Simulate file selection dialog
    await Future.delayed(const Duration(milliseconds: 300));
    
    medicalLicenseFileName.value = 'medical_license_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    Get.snackbar(
      'Document Selected',
      'Medical License selected for upload',
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

    for (final day in selectedAvailability) {
      final selectedSlot = selectedDayTimeSlots[day];
      final selectedMode = selectedDayConsultationModes[day];
      if (selectedSlot == null || selectedSlot.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please select a time slot for $day',
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
      // TODO: API call to submit registration
      // Create doctor object with form data
      // final doctor = Doctor(
      //   id: '',
      //   fullName: fullNameController.text,
      //   email: emailController.text,
      //   mobileNumber: mobileController.text,
      //   qualification: qualificationController.text,
      //   specialization: specializationController.text.isEmpty
      //       ? null
      //       : specializationController.text,
      //   yearOfGraduation: int.tryParse(graduationYearController.text),
      //   yearsOfExperience: int.parse(experienceController.text),
      //   clinicAddress: clinicAddressController.text,
      //   licenseNumber: licenseNumberController.text,
      //   medicalLicenseUrl: medicalLicenseFileName.value,
      //   availability: selectedAvailability.toList(),
      //   dayTimeSlots: selectedDayTimeSlots,
      //   dayConsultationModes: selectedDayConsultationModes,
      //   offersHomeTreatment: offersHomeTreatment.value,
      //   status: 'Pending Approval',
      //   createdAt: DateTime.now(),
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));

      registrationStatus.value = 'Pending Approval';

      Get.snackbar(
        'Success',
        'Registration submitted for admin approval. Status: Pending Approval',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate to pending verification page after snackbar
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/pending-verification', arguments: {
        'registrationType': 'Doctor',
        'userEmail': emailController.text,
      });
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
