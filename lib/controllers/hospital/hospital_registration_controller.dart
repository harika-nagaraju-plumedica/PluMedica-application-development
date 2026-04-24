import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validation_utils.dart';
import '../../services/patient_session_service.dart';

/// Hospital Registration Controller
class HospitalRegistrationController extends GetxController {
  // Form controllers
  final legalNameController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final gstinController = TextEditingController();
  final ceRegistrationController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();

  // Observable state
  final isLoading = false.obs;
  final registrationFormKey = GlobalKey<FormState>();
  final gstCertificateFileName = Rx<String?>(null);
  final ceLicenseFileName = Rx<String?>(null);
  
  // Verification status tracking
  final gstCertificateStatus = Rx<String>(''); // 'pending', 'verified', 'rejected'
  final ceLicenseStatus = Rx<String>(''); // 'pending', 'verified', 'rejected'
  final registrationStatus = Rx<String>('Pending Verification');

  // States and Cities for dropdowns
  final List<String> statesList = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chhattisgarh',
    'Chandigarh',
    'Dadra and Nagar Haveli',
    'Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  final Map<String, List<String>> citiesByState = {
    'Delhi': ['New Delhi', 'Delhi Cantonment', 'East Delhi'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Thane', 'Aurangabad'],
    'Karnataka': ['Bangalore', 'Mysore', 'Hubli', 'Mangalore', 'Belgaum'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Salem', 'Tiruppur'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Agra', 'Varanasi', 'Allahabad'],
    'Gujarat': ['Ahmedabad', 'Surat', 'Vadodara', 'Rajkot', 'Jamnagar'],
    'Rajasthan': ['Jaipur', 'Jodhpur', 'Udaipur', 'Kota', 'Ajmer'],
    'West Bengal': ['Kolkata', 'Darjeeling', 'Siliguri', 'Asansol', 'Durgapur'],
    'Haryana': ['Chandigarh', 'Gurgaon', 'Faridabad', 'Hisar', 'Karnal'],
    // Add more states and cities as needed
  };

  final selectedCities = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.hospital);
    if (isRegistered) {
      Get.offAllNamed('/hospital/login');
    }
  }

  /// Get cities for selected state
  List<String> getCitiesForState(String state) {
    return citiesByState[state] ?? [];
  }

  /// Validate legal hospital name
  String? validateHospitalName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hospital name is required';
    }
    if (!ValidationUtils.isValidHospitalName(value)) {
      return ValidationUtils.getHospitalNameErrorMessage(value);
    }
    return null;
  }

  /// Validate state selection
  String? validateState(String? value) {
    if (value == null || value.isEmpty) {
      return 'State is required';
    }
    return null;
  }

  /// Validate city selection
  String? validateCity(String? value) {
    if (value == null || value.isEmpty) {
      return 'City is required';
    }
    return null;
  }

  /// Validate GSTIN Number
  String? validateGSTIN(String? value) {
    if (value == null || value.isEmpty) {
      return 'GSTIN Number is required';
    }
    if (!ValidationUtils.isValidGSTIN(value)) {
      return ValidationUtils.getGSTINErrorMessage(value);
    }
    return null;
  }

  /// Validate CE Registration Number
  String? validateCENumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'CE Registration Number is required';
    }
    if (!ValidationUtils.isValidCENumber(value)) {
      return ValidationUtils.getCENumberErrorMessage(value);
    }
    return null;
  }

  /// Validate email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!ValidationUtils.isValidEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validate mobile number
  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (!ValidationUtils.isValidMobileNumber(value)) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  /// Upload GST Certificate
  Future<void> uploadGSTCertificate() async {
    // TODO: Implement actual file picker
    // Simulate file selection dialog
    await Future.delayed(const Duration(milliseconds: 300));
    
    gstCertificateFileName.value = 'gst_certificate_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    Get.snackbar(
      'Document Selected',
      'GST Certificate selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Upload CE License
  Future<void> uploadCELicense() async {
    // TODO: Implement actual file picker
    // Simulate file selection dialog
    await Future.delayed(const Duration(milliseconds: 300));
    
    ceLicenseFileName.value = 'ce_license_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    Get.snackbar(
      'Document Selected',
      'CE License selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Submit hospital registration
  Future<void> submitRegistration() async {
    if (!registrationFormKey.currentState!.validate()) {
      return;
    }

    // Check if all documents are uploaded
    if (!ValidationUtils.hasAllRequiredDocuments(
      gstCertificateFileName.value,
      ceLicenseFileName.value,
    )) {
      Get.snackbar(
        'Validation Error',
        ValidationUtils.getDocumentUploadErrorMessage(
          gstCertificateFileName.value,
          ceLicenseFileName.value,
        ),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      // TODO: API call to submit registration
      // Create hospital object with form data
      // final hospital = Hospital(
      //   id: '',
      //   legalRegisteredName: legalNameController.text,
      //   state: stateController.text,
      //   city: cityController.text,
      //   gstinNumber: gstinController.text,
      //   ceRegistrationNumber: ceRegistrationController.text,
      //   email: emailController.text,
      //   mobileNumber: mobileController.text,
      //   address: addressController.text,
      //   gstCertificateUrl: gstCertificateFileName.value,
      //   ceLicenseUrl: ceLicenseFileName.value,
      //   status: 'Pending Verification',
      //   gstinVerified: false,
      //   ceVerified: false,
      //   createdAt: DateTime.now(),
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      await PatientSessionService.markRoleLoggedIn(
        AppRole.hospital,
        email: emailController.text,
      );

      registrationStatus.value = 'Approved';

      Get.snackbar(
        'Success',
        'Hospital registration successful. Welcome to Plumedica!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/hospital/dashboard');
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
    legalNameController.dispose();
    stateController.dispose();
    cityController.dispose();
    gstinController.dispose();
    ceRegistrationController.dispose();
    emailController.dispose();
    mobileController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
