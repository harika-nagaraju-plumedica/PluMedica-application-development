import 'base_model.dart';

/// Pharmacy data model with GSTIN and Drug License
class Pharmacy extends BaseModel {
  final String id;
  final String legalPharmacyName; // Legal Pharmacy Name
  final String state;
  final String city;
  final String gstinNumber; // 15 characters
  final String pharmacyPhoneNumber; // 10-digit mobile number
  
  // Optional: Drug License Information
  final String? drugLicenseNumber;
  final String? licensType; // 'Retail' or 'Wholesale'
  
  // Document URLs
  final String? gstCertificateUrl;
  final String? drugLicenseCertificateUrl;
  
  // Verification status
  final String status; // "Pending Verification", "Approved", "Rejected"
  final bool gstinVerified;
  final bool drugLicenseVerified;
  final String? rejectionReason; // Reason if rejected
  final String? verificationNotes;
  
  final DateTime createdAt;
  final DateTime? verifiedAt;

  Pharmacy({
    required this.id,
    required this.legalPharmacyName,
    required this.state,
    required this.city,
    required this.gstinNumber,
    required this.pharmacyPhoneNumber,
    this.drugLicenseNumber,
    this.licensType,
    this.gstCertificateUrl,
    this.drugLicenseCertificateUrl,
    required this.status,
    required this.gstinVerified,
    required this.drugLicenseVerified,
    this.rejectionReason,
    this.verificationNotes,
    required this.createdAt,
    this.verifiedAt,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'legalPharmacyName': legalPharmacyName,
    'state': state,
    'city': city,
    'gstinNumber': gstinNumber,
    'pharmacyPhoneNumber': pharmacyPhoneNumber,
    'drugLicenseNumber': drugLicenseNumber,
    'licensType': licensType,
    'gstCertificateUrl': gstCertificateUrl,
    'drugLicenseCertificateUrl': drugLicenseCertificateUrl,
    'status': status,
    'gstinVerified': gstinVerified,
    'drugLicenseVerified': drugLicenseVerified,
    'rejectionReason': rejectionReason,
    'verificationNotes': verificationNotes,
    'createdAt': createdAt.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
  };

  factory Pharmacy.fromJson(Map<String, dynamic> json) => Pharmacy(
    id: json['id'] ?? '',
    legalPharmacyName: json['legalPharmacyName'] ?? '',
    state: json['state'] ?? '',
    city: json['city'] ?? '',
    gstinNumber: json['gstinNumber'] ?? '',
    pharmacyPhoneNumber: json['pharmacyPhoneNumber'] ?? '',
    drugLicenseNumber: json['drugLicenseNumber'],
    licensType: json['licensType'],
    gstCertificateUrl: json['gstCertificateUrl'],
    drugLicenseCertificateUrl: json['drugLicenseCertificateUrl'],
    status: json['status'] ?? 'Pending Verification',
    gstinVerified: json['gstinVerified'] ?? false,
    drugLicenseVerified: json['drugLicenseVerified'] ?? false,
    rejectionReason: json['rejectionReason'],
    verificationNotes: json['verificationNotes'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt']) : null,
  );

  /// Check if pharmacy is approved
  bool isApproved() => status == 'Approved';

  /// Check if pharmacy registration is pending
  bool isPending() => status == 'Pending Verification';

  /// Check if pharmacy registration is rejected
  bool isRejected() => status == 'Rejected';

  /// Check if GSTIN is verified
  bool isGstinVerified() => gstinVerified;

  /// Check if drug license is verified (if provided)
  bool isDrugLicenseVerified() => drugLicenseVerified || drugLicenseNumber == null;

  /// Check if all required verifications are complete
  bool isFullyVerified() => gstinVerified && isDrugLicenseVerified();
}
