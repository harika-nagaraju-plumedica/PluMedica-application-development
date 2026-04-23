import 'base_model.dart';

/// Appointment data model
class Appointment extends BaseModel {
  final String id;
  final String doctorId;
  final String patientId;
  final String patientName;
  final String mode; // Virtual, In-Person
  final DateTime appointmentDate;
  final String timeSlot;
  final String status; // Pending, Completed, Cancelled
  final String? reason;
  final String? notes;
  final DateTime createdAt;

  Appointment({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.patientName,
    required this.mode,
    required this.appointmentDate,
    required this.timeSlot,
    required this.status,
    this.reason,
    this.notes,
    required this.createdAt,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'doctorId': doctorId,
    'patientId': patientId,
    'patientName': patientName,
    'mode': mode,
    'appointmentDate': appointmentDate.toIso8601String(),
    'timeSlot': timeSlot,
    'status': status,
    'reason': reason,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
    id: json['id'] ?? '',
    doctorId: json['doctorId'] ?? '',
    patientId: json['patientId'] ?? '',
    patientName: json['patientName'] ?? '',
    mode: json['mode'] ?? 'Virtual',
    appointmentDate: DateTime.tryParse(json['appointmentDate'] ?? '') ?? DateTime.now(),
    timeSlot: json['timeSlot'] ?? '',
    status: json['status'] ?? 'Pending',
    reason: json['reason'],
    notes: json['notes'],
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );
}
