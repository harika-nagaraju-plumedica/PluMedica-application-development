import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/validation_utils.dart';

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
    // TODO: Implement actual file picker
    // For now, using mock implementation that simulates file selection
    
    // Simulate file selection dialog
    await Future.delayed(const Duration(milliseconds: 300));
    
    // After file is selected, set filename without pending status
    gstCertificateFileName.value = 'gst_certificate_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    Get.snackbar(
      'Document Selected',
      'GST Certificate selected for upload',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  /// Upload Drug License Certificate
  Future<void> uploadDrugLicenseCertificate() async {
    // TODO: Implement actual file picker
    // For now, using mock implementation that simulates file selection
    
    if (!hasDrugLicense.value) {
      Get.snackbar(
        'Error',
        'Please enable Drug License checkbox first',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Simulate file selection dialog
    await Future.delayed(const Duration(milliseconds: 300));
    
    // After file is selected, set filename without pending status
    drugLicenseCertificateFileName.value = 'drug_license_${DateTime.now().millisecondsSinceEpoch}.pdf';
    
    Get.snackbar(
      'Document Selected',
      'Drug License Certificate selected for upload',
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

      registrationStatus.value = 'Pending Verification';

      Get.snackbar(
        'Success',
        'Pharmacy registration submitted. Status: Pending Verification',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );

      // Navigate to pending verification page
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offNamed('/pending-verification', arguments: {
        'registrationType': 'Pharmacy',
        'userEmail': '', // TODO: Get from user session
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
    legalPharmacyNameController.dispose();
    stateController.dispose();
    cityController.dispose();
    pharmacyPhoneController.dispose();
    gstinController.dispose();
    drugLicenseNumberController.dispose();
    super.onClose();
  }
}
