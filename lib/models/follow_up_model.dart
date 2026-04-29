import 'base_model.dart';

/// Follow-up model linked to a previous prescription.
class FollowUpRecord extends BaseModel {
  final String id;
  final String prescriptionId;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String notes;
  final String? updatedMedication;
  final DateTime nextVisitDate;
  final DateTime createdAt;

  FollowUpRecord({
    required this.id,
    required this.prescriptionId,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.notes,
    this.updatedMedication,
    required this.nextVisitDate,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'prescriptionId': prescriptionId,
    'patientId': patientId,
    'patientName': patientName,
    'doctorId': doctorId,
    'doctorName': doctorName,
    'notes': notes,
    'updatedMedication': updatedMedication,
    'nextVisitDate': nextVisitDate.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory FollowUpRecord.fromJson(Map<String, dynamic> json) {
    return FollowUpRecord(
      id: json['id'] ?? '',
      prescriptionId: json['prescriptionId'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      notes: json['notes'] ?? '',
      updatedMedication: json['updatedMedication'],
      nextVisitDate:
          DateTime.tryParse(json['nextVisitDate'] ?? '') ?? DateTime.now(),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
