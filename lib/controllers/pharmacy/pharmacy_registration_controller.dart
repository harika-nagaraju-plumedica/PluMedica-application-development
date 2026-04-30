import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validation_utils.dart';
import '../../utils/file_pick_utils.dart';
import '../../services/patient_session_service.dart';

/// Pharmacy Registration Controller
class PharmacyRegistrationController extends GetxController {
  // Form controllers
  final legalPharmacyNameController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final pharmacyPhoneController = TextEditingController();
  final gstinController = TextEditingController();
  final drugLicenseNumberController = TextEditingController();

  // Observable state
  final isLoading = false.obs;
  final registrationFormKey = GlobalKey<FormState>();
  
  // Document upload state
  final gstCertificateFileName = Rx<String?>(null);
  final drugLicenseCertificateFileName = Rx<String?>(null);
  
  // Verification status tracking
  final gstCertificateStatus = Rx<String>(''); // 'pending', 'verified', 'rejected'
  final drugLicenseCertificateStatus = Rx<String>(''); // 'pending', 'verified', 'rejected'
  final registrationStatus = Rx<String>('Pending Verification');
  
  // License type selection
  final licensType = Rx<String?>(null); // 'Retail' or 'Wholesale'
  final hasDrugLicense = false.obs;

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
    'Goa': ['Panaji', 'Margao', 'Vasco da Gama'],
    'Kerala': ['Kochi', 'Thiruvananthapuram', 'Kozhikode', 'Thrissur'],
    'Punjab': ['Chandigarh', 'Amritsar', 'Ludhiana', 'Jalandhar'],
    // Add more states and cities as needed
  };

  final selectedCities = <String>[].obs;

  // Drug license types
  final List<String> retailLicenseTypes = ['Form 20', 'Form 21'];
  final List<String> wholesaleLicenseTypes = ['Form 20B', 'Form 21B'];
  final selectedLicenseForm = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _redirectIfAlreadyRegistered();
  }

  Future<void> _redirectIfAlreadyRegistered() async {
    final isRegistered = await PatientSessionService.isRoleRegistered(AppRole.pharmacy);
    if (isRegistered) {
      Get.offAllNamed('/pharmacy/login');
    }
  }

  /// Get cities for selected state
  List<String> getCitiesForState(String state) {
    return citiesByState[state] ?? [];
  }

  /// Validate legal pharmacy name
  String? validatePharmacyName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Legal Pharmacy Name is required';
    }
    if (value.length < 3) {
      return 'Pharmacy name must be at least 3 characters';
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

  /// Validate pharmacy phone number (10 digits)
  String? validatePharmacyPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pharmacy Phone Number is required';
    }
    if (!ValidationUtils.isValidMobileNumber(value)) {
      return 'Phone number must be 10 digits';
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

  /// Validate drug license number (optional, if provided)
  String? validateDrugLicense(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 3) {
        return 'Drug License Number must be valid';
      }
    }
    return null;
  }

  /// Set drug license flag
  void setHasDrugLicense(bool value) {
    hasDrugLicense.value = value;
    if (!value) {
      // Clear drug license fields when unchecked
      drugLicenseNumberController.clear();
      selectedLicenseForm.value = null;
      licensType.value = null;
      drugLicenseCertificateFileName.value = null;
    }
  }

  /// Set license type (Retail or Wholesale)
  void setLicenseType(String type) {
    licensType.value = type;
    selectedLicenseForm.value = null; // Reset form selection
  }

  /// Get available license forms based on type
  List<String> getAvailableLicenseForms() {
    if (licensType.value == 'Retail') {
      return retailLicenseTypes;
    } else if (licensType.value == 'Wholesale') {
      return wholesaleLicenseTypes;
    }
    return [];
  }

  /// Upload GST Certificate
  Future<void> uploadGSTCertificate() async {
    final fileName = await FilePickUtils.pickSingleFileName(
      dialogTitle: 'Select GST Certificate',
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

    gstCertificateFileName.value = fileName;

    Get.snackbar(
      'Document Selected',
      '$fileName selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Upload Drug License Certificate
  Future<void> uploadDrugLicenseCertificate() async {
    if (!hasDrugLicense.value) {
      Get.snackbar(
        'Error',
        'Please enable Drug License checkbox first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final fileName = await FilePickUtils.pickSingleFileName(
      dialogTitle: 'Select Drug License Certificate',
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

    drugLicenseCertificateFileName.value = fileName;

    Get.snackbar(
      'Document Selected',
      '$fileName selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Preview GST Certificate
  void previewGSTCertificate() {
    if (gstCertificateFileName.value == null) {
      Get.snackbar(
        'Error',
        'No GST Certificate uploaded yet',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Preview',
      'GST Certificate Preview: ${gstCertificateFileName.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Implement document preview dialog
  }

  /// Preview Drug License Certificate
  void previewDrugLicenseCertificate() {
    if (drugLicenseCertificateFileName.value == null) {
      Get.snackbar(
        'Error',
        'No Drug License Certificate uploaded yet',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    Get.snackbar(
      'Preview',
      'Drug License Preview: ${drugLicenseCertificateFileName.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Implement document preview dialog
  }

  /// Submit pharmacy registration
  Future<void> submitRegistration() async {
    // First validate the form
    if (!registrationFormKey.currentState!.validate()) {
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Additional validation: ensure state is selected
    if (stateController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please select a state',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Additional validation: ensure city is filled
    if (cityController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a city',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Notes: Documents are optional - users can submit without them
    // Admin will review whatever documents are uploaded

    isLoading.value = true;

    try {
      // TODO: API call to submit registration
      // Create pharmacy object with form data
      // final pharmacy = Pharmacy(
      //   id: '',
      //   legalPharmacyName: legalPharmacyNameController.text,
      //   state: stateController.text,
      //   city: cityController.text,
      //   pharmacyPhoneNumber: pharmacyPhoneController.text,
      //   gstinNumber: gstinController.text,
      //   drugLicenseNumber: hasDrugLicense.value ? drugLicenseNumberController.text : null,
      //   licensType: licensType.value,
      //   gstCertificateUrl: gstCertificateFileName.value,
      //   drugLicenseCertificateUrl: drugLicenseCertificateFileName.value,
      //   status: 'Pending Verification',
      //   gstinVerified: false,
      //   drugLicenseVerified: false,
      //   createdAt: DateTime.now(),
      // );

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 2));
      await PatientSessionService.markRoleLoggedIn(AppRole.pharmacy);

      registrationStatus.value = 'Approved';

      Get.snackbar(
        'Success',
        'Pharmacy registration successful. Welcome to Plumedica!',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed('/pharmacy/dashboard');
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
    legalPharmacyNameController.dispose();
    stateController.dispose();
    cityController.dispose();
    pharmacyPhoneController.dispose();
    gstinController.dispose();
    drugLicenseNumberController.dispose();
    super.onClose();
  }
}
