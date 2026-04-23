/// Validation utilities for hospital registration
class ValidationUtils {
  /// Validate GSTIN Number (15 characters format)
  /// Format: AA AAAA A1234A1Z5
  static bool isValidGSTIN(String gstin) {
    if (gstin.isEmpty || gstin.length != 15) {
      return false;
    }

    // GSTIN format validation: 15 alphanumeric characters
    final gstinPattern = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');
    return gstinPattern.hasMatch(gstin.toUpperCase());
  }

  /// Get GSTIN error message
  static String getGSTINErrorMessage(String gstin) {
    if (gstin.isEmpty) {
      return 'GSTIN Number is required';
    }
    if (gstin.length != 15) {
      return 'GSTIN must be exactly 15 characters';
    }
    if (!isValidGSTIN(gstin)) {
      return 'Invalid GSTIN format. Expected format: 22AABCP9121A1Z0';
    }
    return '';
  }

  /// Validate CE (Clinical Establishment) Registration Number
  /// Format varies by state, typically: 2 letter state code + 6-8 digits
  static bool isValidCENumber(String ceNumber) {
    if (ceNumber.isEmpty || ceNumber.length < 5) {
      return false;
    }

    // CE number format: 2 letters + numbers, typically 8-12 characters total
    final cePattern = RegExp(r'^[A-Z]{2}[0-9]{6,}$');
    return cePattern.hasMatch(ceNumber.toUpperCase());
  }

  /// Get CE Number error message
  static String getCENumberErrorMessage(String ceNumber) {
    if (ceNumber.isEmpty) {
      return 'CE Registration Number is required';
    }
    if (ceNumber.length < 5) {
      return 'CE Number must be at least 5 characters';
    }
    if (!isValidCENumber(ceNumber)) {
      return 'Invalid CE Number format. Expected format: StateCode + Numbers (e.g., UT20120001)';
    }
    return '';
  }

  /// Validate Mobile Number (10 digits Indian format)
  static bool isValidMobileNumber(String phone) {
    if (phone.isEmpty || phone.length != 10) {
      return false;
    }
    return RegExp(r'^[0-9]{10}$').hasMatch(phone);
  }

  /// Validate Email
  static bool isValidEmail(String email) {
    if (email.isEmpty) {
      return false;
    }
    final emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(email);
  }

  /// Validate Hospital Name
  static bool isValidHospitalName(String name) {
    return name.isNotEmpty && name.length >= 3;
  }

  /// Get Hospital Name error message
  static String getHospitalNameErrorMessage(String name) {
    if (name.isEmpty) {
      return 'Hospital name is required';
    }
    if (name.length < 3) {
      return 'Hospital name must be at least 3 characters';
    }
    return '';
  }

  /// Validate that all required documents are uploaded
  static bool hasAllRequiredDocuments(
    String? gstCertificate,
    String? ceLicense,
  ) {
    return gstCertificate != null &&
        gstCertificate.isNotEmpty &&
        ceLicense != null &&
        ceLicense.isNotEmpty;
  }

  /// Get document upload error message
  static String getDocumentUploadErrorMessage(
    String? gstCertificate,
    String? ceLicense,
  ) {
    if (gstCertificate == null || gstCertificate.isEmpty) {
      return 'GST Certificate is required';
    }
    if (ceLicense == null || ceLicense.isEmpty) {
      return 'CE License is required';
    }
    return '';
  }
}
