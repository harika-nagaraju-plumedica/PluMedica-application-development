import 'base_model.dart';

/// Prescription data model
class Prescription extends BaseModel {
  final String id;
  final String doctorId;
  final String patientId;
  final String medicationName;
  final String dosage;
  final String frequency;
  final int duration; // in days
  final String instructions;
  final DateTime createdAt;
  final DateTime? expiryDate;

  Prescription({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.duration,
    required this.instructions,
    required this.createdAt,
    this.expiryDate,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'patientId': patientId,
    'medicationName': medicationName,
    'dosage': dosage,
    'frequency': frequency,
    'duration': duration,
    'instructions': instructions,
    'createdAt': createdAt.toIso8601String(),
    'expiryDate': expiryDate?.toIso8601String(),
  };

  factory Prescription.fromJson(Map<String, dynamic> json) => Prescription(
    id: json['id'] ?? '',
    doctorId: json['doctorId'] ?? '',
    patientId: json['patientId'] ?? '',
    medicationName: json['medicationName'] ?? '',
    dosage: json['dosage'] ?? '',
    frequency: json['frequency'] ?? '',
    duration: json['duration'] ?? 0,
    instructions: json['instructions'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    expiryDate: json['expiryDate'] != null ? DateTime.tryParse(json['expiryDate']) : null,
  );
}
