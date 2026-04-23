import 'base_model.dart';

/// Hospital data model with GSTIN and CE verification
class Hospital extends BaseModel {
  final String id;
  final String legalRegisteredName; // Legal Registered Hospital Name
  final String state;
  final String city;
  final String gstinNumber; // 15 characters
  final String ceRegistrationNumber; // CE Registration Number
  final String email;
  final String mobileNumber;
  final String? address;
  final String? specializations;
  
  // Document URLs
  final String? gstCertificateUrl;
  final String? ceLicenseUrl;
  
  // Verification status
  final String status; // "Pending Verification", "Verified", "Rejected", "Active"
  final bool gstinVerified;
  final bool ceVerified;
  final String? verificationNotes;
  
  final DateTime createdAt;
  final DateTime? verifiedAt;

  Hospital({
    required this.id,
    required this.legalRegisteredName,
    required this.state,
    required this.city,
    required this.gstinNumber,
    required this.ceRegistrationNumber,
    required this.email,
    required this.mobileNumber,
    this.address,
    this.specializations,
    this.gstCertificateUrl,
    this.ceLicenseUrl,
    required this.status,
    required this.gstinVerified,
    required this.ceVerified,
    this.verificationNotes,
    required this.createdAt,
    this.verifiedAt,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'legalRegisteredName': legalRegisteredName,
    'state': state,
    'city': city,
    'gstinNumber': gstinNumber,
    'ceRegistrationNumber': ceRegistrationNumber,
    'email': email,
    'mobileNumber': mobileNumber,
    'address': address,
    'specializations': specializations,
    'gstCertificateUrl': gstCertificateUrl,
    'ceLicenseUrl': ceLicenseUrl,
    'status': status,
    'gstinVerified': gstinVerified,
    'ceVerified': ceVerified,
    'verificationNotes': verificationNotes,
    'createdAt': createdAt.toIso8601String(),
    'verifiedAt': verifiedAt?.toIso8601String(),
  };

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
    id: json['id'] ?? '',
    legalRegisteredName: json['legalRegisteredName'] ?? '',
    state: json['state'] ?? '',
    city: json['city'] ?? '',
    gstinNumber: json['gstinNumber'] ?? '',
    ceRegistrationNumber: json['ceRegistrationNumber'] ?? '',
    email: json['email'] ?? '',
    mobileNumber: json['mobileNumber'] ?? '',
    address: json['address'],
    specializations: json['specializations'],
    gstCertificateUrl: json['gstCertificateUrl'],
    ceLicenseUrl: json['ceLicenseUrl'],
    status: json['status'] ?? 'Pending Verification',
    gstinVerified: json['gstinVerified'] ?? false,
    ceVerified: json['ceVerified'] ?? false,
    verificationNotes: json['verificationNotes'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    verifiedAt: json['verifiedAt'] != null ? DateTime.tryParse(json['verifiedAt']) : null,
  );

  /// Check if hospital is fully verified
  bool isFullyVerified() => gstinVerified && ceVerified;

  /// Check if hospital can be marked as active
  bool canBeActive() => isFullyVerified() && status == 'Verified';
}
