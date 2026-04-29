import 'base_model.dart';

class AvailabilitySlot {
  final String label;
  final String status; // Free, Booked

  AvailabilitySlot({
    required this.label,
    this.status = 'Free',
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'status': status,
  };

  factory AvailabilitySlot.fromJson(Map<String, dynamic> json) {
    return AvailabilitySlot(
      label: json['label'] ?? '',
      status: json['status'] ?? 'Free',
    );
  }
}

/// Doctor data model
class Doctor extends BaseModel {
  final String id;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String qualification;
  final String? specialization;
  final Map<String, List<String>> specializationMapping;
  final String area;
  final int? yearOfGraduation;
  final int yearsOfExperience;
  final String clinicAddress;
  final String licenseNumber;
  final String? medicalLicenseUrl; // Medical License Upload (renamed from resumeUrl)
  final List<String> availability;
  final Map<String, List<AvailabilitySlot>> weeklyAvailability;
  final Map<String, String>? dayTimeSlots;
  final Map<String, String>? dayConsultationModes;
  final bool isAvailabilityActive;
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
    this.specializationMapping = const {},
    this.area = '',
    this.yearOfGraduation,
    required this.yearsOfExperience,
    required this.clinicAddress,
    required this.licenseNumber,
    this.medicalLicenseUrl,
    required this.availability,
    this.weeklyAvailability = const {},
    this.dayTimeSlots,
    this.dayConsultationModes,
    this.isAvailabilityActive = true,
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
    'specializationMapping': specializationMapping,
    'area': area,
    'yearOfGraduation': yearOfGraduation,
    'yearsOfExperience': yearsOfExperience,
    'clinicAddress': clinicAddress,
    'licenseNumber': licenseNumber,
    'medicalLicenseUrl': medicalLicenseUrl,
    'availability': availability,
    'weeklyAvailability': weeklyAvailability.map(
      (day, slots) => MapEntry(
        day,
        slots.map((slot) => slot.toJson()).toList(),
      ),
    ),
    'dayTimeSlots': dayTimeSlots,
    'dayConsultationModes': dayConsultationModes,
    'isAvailabilityActive': isAvailabilityActive,
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
    specializationMapping: json['specializationMapping'] != null
      ? Map<String, List<String>>.from(
          (json['specializationMapping'] as Map).map(
            (key, value) => MapEntry(
              key.toString(),
              List<String>.from(value ?? []),
            ),
          ),
        )
      : const {},
    area: json['area'] ?? '',
    yearOfGraduation: json['yearOfGraduation'] != null
      ? int.tryParse(json['yearOfGraduation'].toString())
      : null,
    yearsOfExperience: json['yearsOfExperience'] ?? 0,
    clinicAddress: json['clinicAddress'] ?? '',
    licenseNumber: json['licenseNumber'] ?? '',
    medicalLicenseUrl: json['medicalLicenseUrl'] ?? json['resumeUrl'], // Support both fields for compatibility
    availability: List<String>.from(json['availability'] ?? []),
    weeklyAvailability: json['weeklyAvailability'] != null
      ? Map<String, List<AvailabilitySlot>>.from(
          (json['weeklyAvailability'] as Map).map(
            (key, value) => MapEntry(
              key.toString(),
              (value as List)
                  .map(
                    (slot) => AvailabilitySlot.fromJson(
                      Map<String, dynamic>.from(slot),
                    ),
                  )
                  .toList(),
            ),
          ),
        )
      : const {},
    dayTimeSlots: json['dayTimeSlots'] != null
      ? Map<String, String>.from(json['dayTimeSlots'])
      : null,
    dayConsultationModes: json['dayConsultationModes'] != null
      ? Map<String, String>.from(json['dayConsultationModes'])
      : null,
    isAvailabilityActive: json['isAvailabilityActive'] ?? true,
    offersHomeTreatment: json['offersHomeTreatment'] ?? false,
    status: json['status'] ?? 'Pending Approval',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    profileImageUrl: json['profileImageUrl'],
  );
}
