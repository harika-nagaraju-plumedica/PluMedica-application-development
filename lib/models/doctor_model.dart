import 'base_model.dart';

/// Doctor data model
class Doctor extends BaseModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String qualification;
  final String? specialization;
  final int? yearOfGraduation;
  final int yearsOfExperience;
  final String clinicAddress;
  final String licenseNumber;
  final String? medicalLicenseUrl; // Medical License Upload (renamed from resumeUrl)
  final List<String> availability;
  final Map<String, String>? dayTimeSlots;
  final Map<String, String>? dayConsultationModes;
  final bool offersHomeTreatment;
  final String status; // "Pending Approval", "approved", "rejected", "Active"
  final DateTime createdAt;
  final String? profileImageUrl;

  Doctor({
    required this.id,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    required this.qualification,
    this.specialization,
    this.yearOfGraduation,
    required this.yearsOfExperience,
    required this.clinicAddress,
    required this.licenseNumber,
    this.medicalLicenseUrl,
    required this.availability,
    this.dayTimeSlots,
    this.dayConsultationModes,
    this.offersHomeTreatment = false,
    required this.status,
    required this.createdAt,
    this.profileImageUrl,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'mobileNumber': mobileNumber,
    'qualification': qualification,
    'specialization': specialization,
    'yearOfGraduation': yearOfGraduation,
    'yearsOfExperience': yearsOfExperience,
    'clinicAddress': clinicAddress,
    'licenseNumber': licenseNumber,
    'medicalLicenseUrl': medicalLicenseUrl,
    'availability': availability,
    'dayTimeSlots': dayTimeSlots,
    'dayConsultationModes': dayConsultationModes,
    'offersHomeTreatment': offersHomeTreatment,
    'status': status,
    'createdAt': createdAt.toIso8601String(),
    'profileImageUrl': profileImageUrl,
  };

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
    id: json['id'] ?? '',
    fullName: json['fullName'] ?? '',
    email: json['email'] ?? '',
    mobileNumber: json['mobileNumber'] ?? '',
    qualification: json['qualification'] ?? '',
    specialization: json['specialization'],
    yearOfGraduation: json['yearOfGraduation'] != null
      ? int.tryParse(json['yearOfGraduation'].toString())
      : null,
    yearsOfExperience: json['yearsOfExperience'] ?? 0,
    clinicAddress: json['clinicAddress'] ?? '',
    licenseNumber: json['licenseNumber'] ?? '',
    medicalLicenseUrl: json['medicalLicenseUrl'] ?? json['resumeUrl'], // Support both fields for compatibility
    availability: List<String>.from(json['availability'] ?? []),
    dayTimeSlots: json['dayTimeSlots'] != null
      ? Map<String, String>.from(json['dayTimeSlots'])
      : null,
    dayConsultationModes: json['dayConsultationModes'] != null
      ? Map<String, String>.from(json['dayConsultationModes'])
      : null,
    offersHomeTreatment: json['offersHomeTreatment'] ?? false,
    status: json['status'] ?? 'Pending Approval',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    profileImageUrl: json['profileImageUrl'],
  );
}
