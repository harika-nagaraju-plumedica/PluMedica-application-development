import 'base_model.dart';

/// Doctor referral model used by both doctor and patient modules.
class DoctorReferral extends BaseModel {
  final String id;
  final String patientId;
  final String patientName;
  final String referredDoctorId;
  final String referredDoctorName;
  final String referringDoctorId;
  final String referringDoctorName;
  final String reason;
  final String description;
  final String? attachmentName;
  final String visitType;
  final DateTime? requestedDate;
  final String? requestedTimeSlot;
  final int? consultationFee;
  final String? doctorSpecialization;
  final String? hospitalOrClinic;
  final String? suggestedTimeSlot;
  final DateTime createdAt;
  final String status; // Pending, Accepted, Rejected, Completed

  DoctorReferral({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.referredDoctorId,
    required this.referredDoctorName,
    required this.referringDoctorId,
    required this.referringDoctorName,
    required this.reason,
    required this.description,
    this.attachmentName,
    this.visitType = 'OP Consultation',
    this.requestedDate,
    this.requestedTimeSlot,
    this.consultationFee,
    this.doctorSpecialization,
    this.hospitalOrClinic,
    this.suggestedTimeSlot,
    required this.createdAt,
    this.status = 'Pending',
  });

  DoctorReferral copyWith({
    String? status,
    String? suggestedTimeSlot,
  }) {
    return DoctorReferral(
      id: id,
      patientId: patientId,
      patientName: patientName,
      referredDoctorId: referredDoctorId,
      referredDoctorName: referredDoctorName,
      referringDoctorId: referringDoctorId,
      referringDoctorName: referringDoctorName,
      reason: reason,
      description: description,
      attachmentName: attachmentName,
      visitType: visitType,
      requestedDate: requestedDate,
      requestedTimeSlot: requestedTimeSlot,
      consultationFee: consultationFee,
      doctorSpecialization: doctorSpecialization,
      hospitalOrClinic: hospitalOrClinic,
      suggestedTimeSlot: suggestedTimeSlot ?? this.suggestedTimeSlot,
      createdAt: createdAt,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'patientId': patientId,
    'patientName': patientName,
    'referredDoctorId': referredDoctorId,
    'referredDoctorName': referredDoctorName,
    'referringDoctorId': referringDoctorId,
    'referringDoctorName': referringDoctorName,
    'reason': reason,
    'description': description,
    'attachmentName': attachmentName,
    'visitType': visitType,
    'requestedDate': requestedDate?.toIso8601String(),
    'requestedTimeSlot': requestedTimeSlot,
    'consultationFee': consultationFee,
    'doctorSpecialization': doctorSpecialization,
    'hospitalOrClinic': hospitalOrClinic,
    'suggestedTimeSlot': suggestedTimeSlot,
    'createdAt': createdAt.toIso8601String(),
    'status': status,
  };

  factory DoctorReferral.fromJson(Map<String, dynamic> json) {
    return DoctorReferral(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      referredDoctorId: json['referredDoctorId'] ?? '',
      referredDoctorName: json['referredDoctorName'] ?? '',
      referringDoctorId: json['referringDoctorId'] ?? '',
      referringDoctorName: json['referringDoctorName'] ?? '',
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      attachmentName: json['attachmentName'],
      visitType: json['visitType'] ?? 'OP Consultation',
      requestedDate: json['requestedDate'] == null
          ? null
          : DateTime.tryParse(json['requestedDate']),
      requestedTimeSlot: json['requestedTimeSlot'],
      consultationFee: json['consultationFee'],
      doctorSpecialization: json['doctorSpecialization'],
      hospitalOrClinic: json['hospitalOrClinic'],
      suggestedTimeSlot: json['suggestedTimeSlot'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'Pending',
    );
  }
}
